-- Integration test: stub jjui dialogs, but run real jj commands in a temp repo.
-- Usage: luajit jjui/tests/workspaces.lua CONFIG_DIRECTORY TEMP_DIRECTORY
local config_dir, temp = arg[1], arg[2]
local current = temp .. "/main"
local actions, bindings, answers, inputs, messages = {}, {}, {}, {}, {}
local rendered, shell_command, did_quit
local pane_handoff
local pane_command = "fish"
local ffi = require("ffi")
ffi.cdef[[int setenv(const char *name, const char *value, int overwrite);]]
local function quote(s) return "'" .. s:gsub("'", "'\\''") .. "'" end
local function process(argv)
  local parts = {}
  for _, part in ipairs(argv) do parts[#parts + 1] = quote(part) end
  local pipe = assert(io.popen(table.concat(parts, " ") .. " 2>" .. quote(temp .. "/stderr") ..
    "; printf '\\n__exit__%s' \"$?\""))
  local output = pipe:read("*a")
  pipe:close()
  local body, code = output:match("^(.*)\n__exit__(%d+)$")
  assert(code, output)
  local errors = assert(io.open(temp .. "/stderr")):read("*a")
  if code ~= "0" then return nil, errors .. (body or "") end
  return body
end
function jj(...)
  local args = {...}
  if args[1] == "util" and args[2] == "exec" and args[3] == "--" then
    if args[4] == "tmux" and args[5] == "display-message" then
      return "%1\t12345\t" .. pane_command .. "\n"
    end
    if args[4] == "tmux" and args[5] == "set-option" then
      pane_handoff = args[#args]
      return ""
    end
    if args[4] == "kill" then return "" end
  end
  local argv = { "jj", "--no-pager", "--color=never", "-R", current }
  for _, part in ipairs(args) do argv[#argv + 1] = part end
  return process(argv)
end
local function must(...)
  local out, err = jj(...)
  assert(out, err)
  return out
end
local function id(rev)
  return must("log", "--no-graph", "-r", rev or "@", "-T", "commit_id")
end
local selected = id()
context = { commit_id = function() return selected end }
function flash(value) messages[#messages + 1] = value end
function split_lines(value)
  local lines = {}
  for line in value:gmatch("[^\n]+") do lines[#lines + 1] = line end
  return lines
end
function input(_) return table.remove(inputs, 1) end
function choose(dialog)
  local answer = table.remove(answers, 1)
  if type(answer) == "function" then return answer(dialog) end
  return answer
end
function change_workspace(path) current = path; return true end
function exec_shell(cmd) shell_command = cmd end
jjui = { ui = { quit = function() did_quit = true end } }
revisions = { refresh = function() end, jump_to_working_copy = function() end }
revset = { reset = function() end }
diff = { show = function(content) rendered = content end }
assert(loadfile(config_dir .. "/config.lua"))()
setup({ repo = current,
  action = function(name, fn) actions[name] = fn end,
  bind = function(binding) bindings[table.concat(binding.seq, " ")] = binding.action end,
})
local function pick(name)
  return function(dialog)
    for _, option in ipairs(dialog.options) do
      if option:find(name .. "  [", 1, true) then return option end
    end
    error("Missing workspace in picker: " .. name)
  end
end
local function error_contains(text)
  local last = messages[#messages]
  assert(type(last) == "table" and last.error and last.text:find(text, 1, true),
    "Missing error: " .. text)
end

for _, key in ipairs({ "l", "a", "o", "g", "f", "shift+f", "r", "-", "s" }) do
  assert(bindings["w " .. key], "Missing binding " .. key)
end
actions.workspace_previous()
error_contains("No previous workspace")
actions.workspace_add() -- cancelled prompt
local feature = temp .. "/main's feature space"
inputs = { "feature", feature }
answers = { "Cancel" }
actions.workspace_add()
assert(must("workspace", "root", "--name", "feature"):match("([^\n]+)") == feature)
assert(id("feature@-") == selected, "New workspace must be a child of highlighted commit")
actions.workspace_list()
assert(rendered:find("* default", 1, true) and rendered:find(feature, 1, true))
answers = { pick("feature") }
actions.workspace_open()
assert(current == feature)
assert(workspace_file_path("a b.txt") == feature .. "/a b.txt")
inputs = { "renamed" }
actions.workspace_rename()
assert(must("workspace", "root", "--name", "renamed"):match("([^\n]+)") == feature)
assert(current == feature, "Rename must not move directory")
answers = { pick("renamed") }
actions.workspace_forget()
error_contains("Switch away")
actions.workspace_previous()
assert(current == temp .. "/main")
actions.workspace_previous()
assert(current == feature, "Previous should toggle")
actions.workspace_previous()
answers = { pick("default") }
actions.workspace_forget()
error_contains("Switch away")
answers = { pick("renamed"), "Cancel" }
actions.workspace_forget()
assert(must("workspace", "root", "--name", "renamed"))
answers = { pick("renamed"), "Forget" }
actions.workspace_forget()
assert(not jj("workspace", "root", "--name", "renamed"))
assert(io.open(feature .. "/.jj/repo"), "Forget must preserve directory")
actions.workspace_previous()
error_contains("No previous workspace")
inputs = { "bad/name" }
actions.workspace_add()
error_contains("Use a name")
inputs = { "default" }
actions.workspace_add()
error_contains("already exists")
inputs = { "second", temp .. "/second" }
answers = { "Open" }
selected = id()
actions.workspace_add()
assert(current == temp .. "/second")
actions.workspace_shell()
assert(shell_command and shell_command:find(quote(current), 1, true), "Shell must use current workspace")
-- Native picker cancellation does not switch anything.
actions.workspace_open()
assert(current == temp .. "/second")
assert(ffi.C.setenv("TMUX", "test,1,0", 1) == 0)
answers = { pick("default") }
actions.workspace_go()
assert(pane_handoff == temp .. "/main")
assert(did_quit, "Go should close jjui after handing off the workspace")
pane_command = "nvim"
pane_handoff, did_quit = nil, false
answers = { pick("default") }
actions.workspace_go()
error_contains("available only from a Fish tmux pane")
assert(not pane_handoff and not did_quit, "Go must not hand off from a non-Fish pane")
print("PASS: bindings, add, list, picker, switch, previous, rename, forget, cancellation, shell, editor paths")
