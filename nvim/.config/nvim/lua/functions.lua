-- Custom functions (converted from init.vim)

local keymap = vim.keymap.set

-- Capture wiki function
local function capture_wiki(is_work)
  local header = vim.fn.input("Header: ", "")
  if header == "" then
    return
  end
  local filename = string.gsub(header, "%s+", "-") .. ".md"
  if is_work then
    filename = "/Users/dghaehre/wikis/work/Inbox/" .. filename
  else
    filename = "/Users/dghaehre/wikis/vimwiki/Inbox/" .. filename
  end
  local out = io.open(filename, "w+")
  if out then
    local t = vim.api.nvim_call_function("strftime", { "%d/%m/%y %H:%M" })
    out:write("# " .. header .. "\n")
    out:write("captured: " .. t .. "\n")
    out:close()
  end
  vim.api.nvim_command("e " .. filename)
end

local function capture_wiki_vimwiki()
  capture_wiki(false)
end

local function capture_wiki_work()
  capture_wiki(true)
end

keymap("n", "<leader>ca", capture_wiki_vimwiki)
keymap("n", "<leader>cja", capture_wiki_work)

-- Generate github link
local function generate_github_link()
  local commit = vim.fn.system("git rev-parse HEAD 2> /dev/null | tr -d '\\n'")
  local linenr = vim.api.nvim_win_get_cursor(0)[1]
  local filename = vim.fn.expand("%")
  local github = string.gsub(
    string.gsub(string.gsub(vim.fn.system("git remote get-url origin 2> /dev/null | tr -d '\\n'"), "git@", "https://"), "%.git", ""),
    "com%:",
    "com/"
  )
  local link = github .. "/blob/" .. commit .. "/" .. filename .. "#L" .. linenr
  vim.fn.setreg("+", link)
  print("copied: " .. link)
end

keymap("n", "<leader>gy", generate_github_link)

-- Open PR from branch
local function open_pr()
  vim.fn.system("gh pr view --web")
end

keymap("n", "<leader>Po", open_pr)

local function create_pr()
  vim.fn.system("gh pr create --web")
end

keymap("n", "<leader>Pc", create_pr)

-- Open last downloaded file
local function open_last_downloaded_file()
  local last_downloaded = vim.fn.system("ls -t ~/Downloads | head -n 1 | tr -d '\\n'")
  vim.api.nvim_command("e ~/Downloads/" .. last_downloaded)
end

keymap("n", "<leader>od", open_last_downloaded_file)

-- Open todo file
local function open_todo_file()
  local line = vim.api.nvim_get_current_line()
  local last_word = line:match(".*%s(%S+)$")
  if last_word then
    -- Check if it looks like a keyword surrounded by colons (e.g., :keyword:)
    if not last_word:match("^:.*:$") then
      print("Did not find a trailing keyword")
      return
    end
    -- Remove the surrounding colons
    last_word = last_word:gsub(":", "")
    vim.api.nvim_command("e ~/wikis/work/todos/" .. last_word .. ".md")
  end
end

keymap("n", "<leader>ot", open_todo_file)

-- Judge function
local function judge()
  local filename = vim.fn.expand("%")
  local linenr = vim.api.nvim_win_get_cursor(0)[1]
  local columnnr = vim.fn.col("$") - 1
  local command = "judge -a " .. filename .. ":" .. linenr .. ":" .. columnnr
  vim.api.nvim_command("silent !" .. command)
end

keymap("n", "<leader>le", judge)

-- Create wikilink function
local function create_wikilink()
  local header = vim.fn.trim(vim.fn.substitute(table.concat(vim.fn.getline(1, 1), ""), "#*", "", ""))
  local list = vim.fn.split(vim.fn.expand("%:p"), "/")
  local path = table.concat({ unpack(list, 5) }, "/")
  return "[" .. header .. "](/" .. path .. ")"
end

keymap("n", "<leader>wy", function()
  vim.fn.setreg('"', create_wikilink())
end)

-- Diff function
function _G.Diff(spec)
  vim.cmd("vertical new")
  vim.cmd("setlocal bufhidden=wipe buftype=nofile nobuflisted noswapfile")
  local cmd = "++edit #"
  if spec and #spec > 0 then
    local git_dir = vim.fn.fnamemodify(vim.fn.finddir(".git", ".;"), ":p:h:h")
    cmd = "!git -C " .. vim.fn.shellescape(git_dir) .. " show " .. spec .. ":#"
  end
  vim.cmd("read " .. cmd)
  vim.cmd("silent 0d_")
  vim.cmd("diffthis")
  vim.cmd("wincmd p")
  vim.cmd("diffthis")
end

vim.api.nvim_create_user_command("Diff", function(opts)
  _G.Diff(opts.args)
end, { nargs = "?" })
