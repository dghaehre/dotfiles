-- Workspace actions inspired by https://github.com/idursun/jjui/discussions/552.
-- Kept here so the picker, path handling and previous-workspace state are shared.
local previous_path
local config_dir = os.getenv("JJUI_CONFIG_DIR") or
  ((os.getenv("XDG_CONFIG_HOME") or (os.getenv("HOME") .. "/.config")) .. "/jjui")

local function fail(message)
  flash({ text = message, error = true })
end

local function command(...)
  local out, err = jj(...)
  if err then fail(tostring(err)); return nil end
  return out
end

local function strip_newline(s)
  return (s:gsub("\r?\n$", ""))
end

local function root()
  local out = command("workspace", "root")
  return out and strip_newline(out)
end

local function quote(s)
  return "'" .. s:gsub("'", "'\\''") .. "'"
end

-- Also used by the existing TOML editor actions after switching workspace.
function workspace_file_path(file)
  local path = root()
  if not path then return nil end
  return path .. "/" .. file
end

local function workspaces()
  local here = root()
  if not here then return nil end
  local out = command("workspace", "list", "-T",
    'name ++ "\t" ++ self.root() ++ "\t" ++ target.change_id().short() ++ "\t" ++ target.description().first_line().replace("\t", " ") ++ "\n"')
  if not out then return nil end
  local entries = {}
  for _, line in ipairs(split_lines(out)) do
    local name, path, id, description = line:match("^([^\t]+)\t([^\t]*)\t([^\t]+)\t(.*)$")
    if not name then fail("Cannot parse workspace list"); return nil end
    entries[#entries + 1] = {
      name = name, path = path, current = path == here,
      label = (path == here and "* " or "  ") .. name .. "  [" .. id .. "]  " ..
        description .. "  — " .. (path ~= "" and path or "path unavailable"),
    }
  end
  return entries
end

local function pick(title)
  local entries = workspaces()
  if not entries then return nil end
  if #entries == 0 then fail("No workspaces found"); return nil end
  local options, by_label = {}, {}
  for _, entry in ipairs(entries) do
    options[#options + 1] = entry.label
    by_label[entry.label] = entry
  end
  local choice = choose({ title = title .. " (/ to filter)", options = options, ordered = true })
  return choice and by_label[choice]
end

local function switch(path)
  if not path or path == "" then fail("Workspace path is unavailable"); return end
  local old = root()
  if not old or old == path then return end
  -- Snapshot outgoing edits and reconcile the target before changing jjui's path.
  if not command("status") or not command("-R", path, "status") then return end
  local ok, err = change_workspace(path)
  if not ok then fail(tostring(err)); return end
  previous_path = old
  revset.reset()
  revisions.refresh({ keep_selections = false })
  revisions.jump_to_working_copy()
  flash("Workspace: " .. path)
end

local function confirm(title, action)
  return choose({ title = title, options = { "Cancel", action }, ordered = true }) == action
end

local function return_to_fish(path)
  if not os.getenv("TMUX") then
    fail("Return to workspace requires a tmux pane running Fish")
    return false
  end
  -- Popup commands do not expand tmux formats. Query the client context from
  -- inside the popup instead; tmux resolves this to the pane that opened it.
  local caller = command("util", "exec", "--", "tmux", "display-message", "-p",
    "#{pane_id}\t#{pane_pid}\t#{pane_current_command}")
  if not caller then return false end
  local pane, pid, process = strip_newline(caller):match("^(%%%d+)\t(%d+)\t([^\t]+)$")
  if not pane or not pid or not process then
    fail("Could not identify the tmux pane that opened jjui")
    return false
  end
  if process ~= "fish" then
    fail("Return to workspace is available only from a Fish tmux pane (current: " .. process .. ")")
    return false
  end
  -- A pane option is scoped to the invoking pane. Fish validates and clears it
  -- before changing directory, so stale or cross-repository paths are ignored.
  if not command("util", "exec", "--", "tmux", "set-option", "-p", "-t", pane,
      "@jjui_workspace_handoff", path) then
    return false
  end
  if not command("util", "exec", "--", "kill", "-USR1", pid) then
    command("util", "exec", "--", "tmux", "set-option", "-p", "-u", "-t", pane,
      "@jjui_workspace_handoff")
    return false
  end
  return true
end

function setup(config)
  local function bind(key, name, description, fn)
    config.action(name, fn, { desc = description })
    config.bind({ seq = { "w", key }, action = name, scope = "revisions", desc = description })
  end

  bind("l", "workspace_list", "list workspaces", function()
    local entries = workspaces()
    if not entries then return end
    local lines = { "Workspaces (* = current)", "" }
    for _, entry in ipairs(entries) do lines[#lines + 1] = entry.label end
    diff.show(table.concat(lines, "\n"))
  end)

  bind("o", "workspace_open", "open workspace", function()
    local entry = pick("Open workspace")
    if entry then switch(entry.path) end
  end)

  bind("g", "workspace_go", "return to workspace in the calling Fish pane", function()
    local entry = pick("Go to workspace in the calling Fish pane")
    if not entry then return end
    if entry.path == "" then
      fail("Workspace path is unavailable")
      return
    end
    if return_to_fish(entry.path) then
      jjui.ui.quit()
    end
  end)

  bind("-", "workspace_previous", "previous workspace", function()
    if not previous_path then fail("No previous workspace in this jjui session"); return end
    -- Resolve against live entries; a forgotten workspace must not be reopened.
    local entries = workspaces()
    if not entries then return end
    for _, entry in ipairs(entries) do
      if entry.path == previous_path then switch(entry.path); return end
    end
    fail("The previous workspace is no longer registered")
  end)

  bind("a", "workspace_add", "add workspace at selected change", function()
    local revision = context.commit_id()
    if not revision or revision == "" then fail("No revision selected"); return end
    local name = input({ title = "New workspace", prompt = "Name: " })
    if not name or name == "" then return end
    if not name:match("^[%w][%w._-]*$") then
      fail("Use a name starting with a letter/number, followed by letters, numbers, '.', '_' or '-'")
      return
    end
    local entries = workspaces()
    if not entries then return end
    local base = config.repo
    for _, entry in ipairs(entries) do
      if entry.name == name then fail("Workspace already exists: " .. name); return end
      if entry.name == "default" and entry.path ~= "" then base = entry.path end
    end
    local path = input({ title = "New workspace", prompt = "Directory: ", value = base .. "." .. name })
    if not path or path == "" then return end
    if path:find("[\r\n\t]") then fail("Directory cannot contain tabs or newlines"); return end
    if path:sub(1, 2) == "~/" then path = os.getenv("HOME") .. path:sub(2) end
    if not command("workspace", "add", "--name", name, "-r", revision, "--", path) then return end
    revisions.refresh({ keep_selections = true })
    flash("Created workspace " .. name)
    if confirm("Created " .. name .. ". Switch to it?", "Open") then
      local destination = command("workspace", "root", "--name", name)
      if destination then switch(strip_newline(destination)) end
    end
  end)

  bind("f", "workspace_forget", "forget workspace (keep directory)", function()
    local entry = pick("Forget workspace (keep directory)")
    if not entry then return end
    if entry.current or entry.name == "default" then
      fail("Switch away first; the default workspace is protected"); return
    end
    if not confirm("Forget " .. entry.name .. "? Keep directory: " .. entry.path, "Forget") then return end
    if entry.path ~= "" and not command("-R", entry.path, "status") then return end
    if not command("workspace", "forget", "--", entry.name) then return end
    if previous_path == entry.path then previous_path = nil end
    revisions.refresh({ keep_selections = true })
    flash("Forgot " .. entry.name .. "; directory kept")
  end)

  bind("shift+f", "workspace_trash", "forget workspace and move directory to Trash", function()
    local entry = pick("Forget workspace and move directory to Trash")
    if not entry then return end
    local here = root()
    if not here then return end
    local args = { "util", "exec", "--", "python3", config_dir .. "/workspace-trash.py",
      entry.name, entry.path, here }
    -- Read-only preflight before confirmation; the helper repeats checks on execution.
    local preflight = { unpack(args) }
    preflight[#preflight + 1] = "--check"
    if not command(unpack(preflight)) then return end
    if not confirm("Forget " .. entry.name .. " and move to Trash?\n" .. entry.path ..
        "\nStop any shells, editors or agents using it first.", "Move to Trash") then return end
    local out = command(unpack(args))
    revisions.refresh({ keep_selections = true })
    if not out then return end
    if previous_path == entry.path then previous_path = nil end
    flash(strip_newline(out))
  end)

  bind("r", "workspace_rename", "rename current workspace (keep directory)", function()
    local entries = workspaces()
    if not entries then return end
    local current
    for _, entry in ipairs(entries) do if entry.current then current = entry end end
    if not current then fail("Current workspace not found"); return end
    local name = input({ title = "Rename current workspace (directory stays unchanged)",
      prompt = "Name: ", value = current.name })
    if not name or name == "" or name == current.name then return end
    if not name:match("^[%w][%w._-]*$") then fail("Invalid workspace name"); return end
    for _, entry in ipairs(entries) do
      if entry.name == name then fail("Workspace already exists: " .. name); return end
    end
    if not command("workspace", "rename", "--", name) then return end
    revisions.refresh({ keep_selections = true })
    flash("Renamed workspace to " .. name .. "; directory unchanged")
  end)

  bind("s", "workspace_shell", "open workspace shell in tmux", function()
    local path = root()
    if not path then return end
    if os.getenv("TMUX") then
      local out = command("util", "exec", "--", "tmux", "new-window", "-c", path)
      if out then flash("Opened tmux window in " .. path) end
    else
      exec_shell("bash -c " .. quote('cd -- "$1" && exec "${SHELL:-/bin/sh}"') ..
        " workspace-shell " .. quote(path))
      revisions.refresh({ keep_selections = true })
    end
  end)
end
