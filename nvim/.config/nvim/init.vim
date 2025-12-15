set rtp^=/usr/share/vim/vimfiles/
set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath = &runtimepath
source ~/.vimrc

lua << EOF

local function log_time(msg)
  local now = os.date("%H:%M:%S")
  local ms = math.floor((os.clock() % 1) * 1000)
  local timestamp = string.format("%s.%03d", now, ms)
  local f = io.open("/tmp/nvim_startup.log", "a")
  if f then
    f:write(timestamp .. " " .. msg .. "\n")
    f:close()
  end
end

log_time("---startup-----")


----------------------------------------------------------------
-- HARPOON
----------------------------------------------------------------

-- If you want git branch detection, use this
-- local function git_branch()
--   local pipe = io.popen("git branch --show-current")
--   if pipe then
--     local c = pipe:read("*l"):match("^%s*(.-)%s*$")
--     pipe:close()
--     return c
--   end
--   return "default list"
-- end

log_time("before harpoon")
local harpoon = require("harpoon")
harpoon.setup({
		settings = {
				save_on_toggle = true,
		},
})
vim.keymap.set("n", "<leader>hh", function() harpoon:list():add() end)
vim.keymap.set("n", "<leader>ho", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end)
vim.keymap.set("n", "<leader>ha", function() harpoon:list():select(1) end)
vim.keymap.set("n", "<leader>hs", function() harpoon:list():select(2) end)
vim.keymap.set("n", "<leader>hd", function() harpoon:list():select(3) end)
vim.keymap.set("n", "<leader>hf", function() harpoon:list():select(4) end)
-- -- Toggle previous & next buffers stored within Harpoon list
vim.keymap.set("n", "<leader>hk", function() harpoon:list():prev() end)
vim.keymap.set("n", "<leader>hj", function() harpoon:list():next() end)


----------------------------------------------------------------
-- TELESCOPE                                                  --
----------------------------------------------------------------

log_time("before telescope")
local telescope = require('telescope')
local actions = require('telescope.actions')
local builtin = require('telescope.builtin')
telescope.setup({
  pickers = {
    buffers = {
      show_all_buffers = true,
      sort_lastused = true,
      mappings = {
        i = {
          ["<c-d>"] = "delete_buffer",
        },
        n = {
          ["<c-d>"] = "delete_buffer",
        }
      }
    }
  },
  defaults = {
    hidden = true,
    mappings = {
      i = {
        ["<C-j>"] = actions.move_selection_next,
        ["<C-k>"] = actions.move_selection_previous,
        ["<C-l>"] = actions.select_vertical,
      },
    },
  },
  extensions = {
    fzf = {
      fuzzy = true,                    -- false will only do exact matching
      override_generic_sorter = false, -- override the generic sorter
      override_file_sorter = true,     -- override the file sorter
      case_mode = "smart_case",        -- or "ignore_case" or "respect_case"
                                       -- the default case_mode is "smart_case"
    }
  }
})

telescope.load_extension('git_worktree')
telescope.load_extension('fzf')
telescope.load_extension('dap')

-- :lua require('telescope').extensions.git_worktree.git_worktrees()
vim.keymap.set("n", "<Leader>gw", function() telescope.extensions.git_worktree.git_worktrees() end, opts)

--------------------------------------------------------------------------
-- Treesitter                                                           --
--------------------------------------------------------------------------

log_time("before treesitter")
local treesitter = require('nvim-treesitter.configs')
treesitter.setup({
  -- ensure_installed = "all",
  highlight = {
    enable = true,    -- false will disable the whole extension
  },
  indentation = {
    enable = true,    -- false will disable the whole extension
  },
  folding = {
    enable = true,    -- false will disable the whole extension
  },
})
require('treesitter-context').setup({
  enable = true,
  max_lines = 1,
  trim_scope = 'inner',
})


------------------------------------------------------------
-- LSP                                                    --
------------------------------------------------------------
log_time("before mason")
require('mason').setup({})
require('mason-lspconfig').setup({
  ensure_installed = {},
  handlers = {
    function(server_name)
      require('lspconfig')[server_name].setup({})
    end,
  }
})

log_time("before lsp-zero")
local lsp = require("lsp-zero")

-- deprecated after new version... probably just delete this..
-- lsp.preset({
--   name = "minimal",
--   manage_nvim_cmp = true,
-- })
-- 
-- lsp.set_preferences({
--   suggest_lsp_servers = true,
--   sign_icons = {
--     error = 'E',
--     warn = 'W',
--     hint = 'H',
--     info = 'I'
--   }
-- })

-- sudo jpm install https://github.com/CFiggers/janet-lsp
local lsp_configurations = require('lspconfig.configs')
if not lsp_configurations.janet_lsp then
  lsp_configurations.janet_lsp = {
    default_config = {
      name = 'janet-lsp',
      cmd = {'janet-lsp'},
      filetypes = {'janet'},
      root_dir = require('lspconfig.util').root_pattern('project.janet')
    }
  }
end
require('lspconfig').janet_lsp.setup({})
-- 
-- -- roc-lang
-- if not lsp_configurations.roc_lsp then
--   lsp_configurations.roc_lsp = {
--     default_config = {
--       name = 'roc-lsp',
--       cmd = {'roc_language_server'},
--       filetypes = {'roc'},
--       root_dir = require('lspconfig.util').root_pattern('main.roc')
--     }
--   }
-- end
-- require('lspconfig').roc_lsp.setup({})


-- require('lspconfig').gleam.setup({})

-- if not lsp_configurations.gleam_lsp then
--   lsp_configurations.gleam_lsp = {
--     default_config = {
--       name = 'gleam-lsp',
--       cmd = {'gleam', 'lsp'},
--       filetypes = {'gleam'},
--       root_dir = require('lspconfig.util').root_pattern('gleam.toml')
--     }
--   }
-- end
-- require('lspconfig').gleam_lsp.setup({})

if not lsp_configurations.swift_lsp then
  lsp_configurations.swift_lsp = {
    default_config = {
      name = 'swift-lsp',
			cmd = { vim.trim(vim.fn.system("xcrun -f sourcekit-lsp")) },
      filetypes = {'swift'},
      root_dir = require('lspconfig.util').root_pattern('buildServer.json')
    }
  }
end
log_time("before swift_lsp.setup")
require('lspconfig').swift_lsp.setup({})

-- Because Xcode takes a very long time to load, we only do it when we have to!
function XcodeSetup()
	require("xcodebuild").setup({})
end
vim.keymap.set('n', '<leader>Xs', function()
  XcodeSetup()
end, { desc = 'Run XcodeSetup' })


log_time("Before cmp.require")
local cmp = require('cmp')

-- wow, its this one that takes a long time!!
log_time("Before cmp.setup")
cmp.setup({
  sources = {
    {name = 'nvim_lsp'}, -- lazy load this one? Pretty sure this is slow
		{name = 'buffer' },
		-- {name = 'files' }, -- might be slow
  },
  mapping = cmp.mapping.preset.insert({
    ['<CR>'] = cmp.mapping.confirm({
      -- documentation says this is important.
      -- I don't know why.
      behavior = cmp.ConfirmBehavior.Replace,
      select = false,
    }),
    ['<C-u>'] = cmp.mapping.scroll_docs(-4),
    ['<C-d>'] = cmp.mapping.scroll_docs(4),
    ['<C-j>'] = cmp.mapping(cmp.mapping.select_next_item()),
    ['<C-k>'] = cmp.mapping(cmp.mapping.select_prev_item()),
    ['<C-l>'] = cmp.mapping.confirm({ select = true }),
  })
})
log_time("After cmp.setup and before lsp.on_attach")

lsp.on_attach(function(client, bufnr)
  local opts = {buffer = bufnr, remap = false}

  vim.keymap.set("n", "gd", function() builtin.lsp_definitions() end, opts)
  vim.keymap.set("n", "gt", function() builtin.lsp_type_definitions() end, opts)
  vim.keymap.set("n", "gD", function() vim.lsp.buf.declaration() end, opts)
  vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)
  vim.keymap.set("n", "gi", function() builtin.lsp_implementations() end, opts)
	vim.keymap.set("n", "gr", function() builtin.lsp_references() end, opts)
  vim.keymap.set("n", "<leader>f", function()
    if vim.bo.filetype == "swift" then
      vim.cmd("silent !swiftformat %")
    else
      vim.lsp.buf.format()
    end
  end, opts)
  vim.keymap.set("n", "ge", function() vim.diagnostic.show_line_diagnostics() end, opts)
  vim.keymap.set("n", "]e", function() vim.diagnostic.goto_next() end, opts)
  vim.keymap.set("n", "[e", function() vim.diagnostic.goto_prev() end, opts)
  vim.keymap.set("n", "<leader>rn", function() vim.lsp.buf.rename() end, opts)
  vim.keymap.set("n", "<leader>ga", function() vim.lsp.buf.code_action() end, opts)

	-- Enable inlay hints for the current buffer
	-- if client.server_capabilities.inlayHintProvider then
	-- 	vim.lsp.buf.inlay_hint(bufnr, true)
	-- end
end)

lsp.setup()

log_time("After lsp.setup()")

--------------------------------------------------------
-- Debugging setup (dap)                              --
--------------------------------------------------------

local ok, dap = pcall(require, "dap")
if ok then
  vim.keymap.set("n", "<leader>db", ":lua require'dap'.toggle_breakpoint()<CR>")
  vim.keymap.set("n", "<leader>dc", ":lua require'dap'.continue()<CR>")
  vim.keymap.set("n", "<leader>do", ":lua require'dap'.step_over()<CR>")
  vim.keymap.set("n", "<leader>dO", ":lua require'dap'.step_out()<CR>")
  vim.keymap.set("n", "<leader>di", ":lua require'dap'.step_into()<CR>")
  vim.keymap.set("n", "<leader>dB", ":lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>")
  vim.keymap.set("n", "<leader>lp", ":lua require'dap'.set_breakpoint(nil, nil, vim.fn.input('Log point message: '))<CR>")
  vim.keymap.set("n", "<leader>dr", ":lua require'dap'.repl.open()<CR>")
  vim.keymap.set("n", "<leader>dt", ":lua require'dap-go'.debug_test()<CR>")

  require('dap-go').setup()

  require("dapui").setup({
    -- Using defaults
    mappings = {
      -- Use a table to apply multiple mappings
      expand = { "<CR>", "<2-LeftMouse>" },
      open = "o",
      remove = "d",
      edit = "e",
      repl = "r",
      toggle = "t",
    },
    expand_lines = false,
    layout = {
      {
        elements = {
          -- Provide as ID strings or tables with "id" and "size" keys
          { id = "scopes", size = 0.50 },
          { id = "watches", size = 0.50 },
        },
        size = 40,
        position = "left", -- Can be "left", "right", "top", "bottom"
      }, {
        elements = {}
      },
    },
  })

  -- Open dap-ui when dap starts
  local dap, dapui = require("dap"), require("dapui")
  dap.listeners.after.event_initialized["dapui_config"] = function()
    dapui.open()
  end
  dap.listeners.before.event_terminated["dapui_config"] = function()
    dapui.close()
  end
  dap.listeners.before.event_exited["dapui_config"] = function()
    dapui.close()
  end
end


---------------------------------------------------------------------
-- Comment.nvim                                                    --
---------------------------------------------------------------------

require('Comment').setup({
  toggler = {
    line = 'gcl'
  },
  extra = { -- This is defaults, but nice to document here
    ---Add comment on the line above
    above = 'gcO',
    ---Add comment on the line below
    below = 'gco',
    ---Add comment at the end of line
    eol = 'gcA',
  }
})


---------------------------------------------------------------------
-- copliot                                                         --
---------------------------------------------------------------------

require("CopilotChat").setup({
  model = 'claude-sonnet-4.5',           -- AI model to use
})
function AskCopilotChat()
	local input = vim.fn.input("Quick Chat: ")
	if input ~= "" then
		require("CopilotChat").ask(input, { selection = require("CopilotChat.select").buffer })
	end
end
vim.api.nvim_set_keymap('n', '<leader>coq', ":lua AskCopilotChat()<CR>", { noremap = true})

---------------------------------------------------------------------
-- venn.nvim                                                    --
---------------------------------------------------------------------
function _G.Toggle_venn()
    local venn_enabled = vim.inspect(vim.b.venn_enabled)
    if venn_enabled == "nil" then
        vim.b.venn_enabled = true
        vim.cmd[[setlocal ve=all]]
        -- draw a line on HJKL keystokes
        vim.api.nvim_buf_set_keymap(0, "n", "J", "<C-v>j:VBox<CR>", {noremap = true})
        vim.api.nvim_buf_set_keymap(0, "n", "K", "<C-v>k:VBox<CR>", {noremap = true})
        vim.api.nvim_buf_set_keymap(0, "n", "L", "<C-v>l:VBox<CR>", {noremap = true})
        vim.api.nvim_buf_set_keymap(0, "n", "H", "<C-v>h:VBox<CR>", {noremap = true})
        -- draw a box by pressing "f" with visual selection
        vim.api.nvim_buf_set_keymap(0, "v", "f", ":VBox<CR>", {noremap = true})
    else
        vim.cmd[[setlocal ve=]]
        vim.cmd[[mapclear <buffer>]]
        vim.b.venn_enabled = nil
    end
end
-- toggle keymappings for venn using <leader>v
vim.api.nvim_set_keymap('n', '<leader>V', ":lua Toggle_venn()<CR>", { noremap = true})


------------------------------------------------------------------
-- Capture vimwiki
------------------------------------------------------------------


function capture_wiki(is_work)
  local header = vim.fn.input("Header: ", "")
  local filename = string.gsub(header, "%s+", "-") .. ".md"
  if is_work then
    filename = "/Users/dghaehre/wikis/work/Inbox/" .. filename
  else
    filename = "/Users/dghaehre/wikis/vimwiki/Inbox/" .. filename
  end
  local out = io.open(filename, "w+")
  local t = vim.api.nvim_call_function('strftime', {'%d/%m/%y %H:%M'})
  out:write("# " .. header .. "\n")
  out:write("captured: " .. t .. "\n")
  out:close()
  vim.api.nvim_command('e ' .. filename)
end

function capture_wiki_vimwiki()
  capture_wiki(false)
end

function capture_wiki_work()
  capture_wiki(true)
end

vim.keymap.set('n', '<Leader>ca', capture_wiki_vimwiki)
vim.keymap.set('n', '<Leader>cja', capture_wiki_work)


------------------------------------------------------------------
-- Generate github link
------------------------------------------------------------------

function generate_github_link()
  local commit = vim.fn.system("git rev-parse HEAD 2> /dev/null | tr -d '\n'")
  local linenr = vim.api.nvim_win_get_cursor(0)[1]
  local filename = vim.fn.expand('%')
  local github = string.gsub(string.gsub(string.gsub(vim.fn.system("git remote get-url origin 2> /dev/null | tr -d '\n'"), "git@", "https://"), "%.git", ""), "com%:", "com/")
  local link = github .. "/blob/" .. commit .. "/" .. filename .. "#L" .. linenr
  vim.fn.setreg('+y', link)
  print("copied: " .. link)
end
vim.keymap.set('n', '<Leader>gy', generate_github_link)

------------------------------------------------------------------
-- Open PR from branch
------------------------------------------------------------------

function open_pr()
  vim.fn.system("gh pr view --web")
end
vim.keymap.set('n', '<Leader>Po', open_pr)
function create_pr()
  vim.fn.system("gh pr create --web")
end
vim.keymap.set('n', '<Leader>Pc', create_pr)

------------------------------------------------------------------
-- Open up last downloaded file
------------------------------------------------------------------

function open_last_downloaded_file()
	local last_downloaded = vim.fn.system("ls -t ~/Downloads | head -n 1 | tr -d '\n'")
	vim.api.nvim_command('e ~/Downloads/' .. last_downloaded)
end
vim.keymap.set('n', '<Leader>od', open_last_downloaded_file)


------------------------------------------------------------------
-- Open up todo file
------------------------------------------------------------------

function open_todo_file()
  local line = vim.api.nvim_get_current_line()
  local last_word = line:match(".*%s(%S+)$"):gsub(":", "")
	if not last_word:match("^:.*:$") then
		print("Did not find a trailing keyword")
	end
	last_word = last_word:gsub(":", "")
	vim.api.nvim_command('e ~/wikis/work/todos/' .. last_word .. ".md")
end
vim.keymap.set('n', '<Leader>ot', open_todo_file)


------------------------------------------------------------------
-- Judge
------------------------------------------------------------------

function judge()
  local filename = vim.fn.expand('%')
  local linenr = vim.api.nvim_win_get_cursor(0)[1]
  local columnnr = vim.fn.col('$')-1
  local command = "judge -a " .. filename .. ":" .. linenr .. ":" .. columnnr
  vim.api.nvim_command('silent !' .. command)
end

vim.keymap.set('n', '<Leader>le', judge)

EOF
