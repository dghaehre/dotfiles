set rtp^=/usr/share/vim/vimfiles/
set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath = &runtimepath
" set termguicolors
source ~/.vimrc

lua << EOF

----------------------------------------------------------------
-- TELESCOPE                                                  --
----------------------------------------------------------------

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

telescope.load_extension('fzf')
telescope.load_extension('dap')


--------------------------------------------------------------------------
-- Treesitter                                                           --
--------------------------------------------------------------------------

local treesitter = require('nvim-treesitter.configs')
treesitter.setup({
  ensure_installed = "all",
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
local lsp = require("lsp-zero")

lsp.preset({
  name = "minimal",
  manage_nvim_cmp = true,
})

lsp.ensure_installed({
  'tsserver',
  'rust_analyzer',
})

lsp.set_preferences({
  suggest_lsp_servers = true,
  sign_icons = {
    error = 'E',
    warn = 'W',
    hint = 'H',
    info = 'I'
  }
})

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

local cmp = require('cmp')
local cmp_action = lsp.cmp_action()
lsp.setup_nvim_cmp({
  mapping = cmp.mapping.preset.insert({
    ['<C-u>'] = cmp.mapping.scroll_docs(-4),
    ['<C-d>'] = cmp.mapping.scroll_docs(4),
    ['<C-j>'] = cmp.mapping(cmp.mapping.select_next_item()),
    ['<C-k>'] = cmp.mapping(cmp.mapping.select_prev_item()),
    ['<C-l>'] = cmp.mapping.confirm({ select = true }),
  }),
  -- documentation = {
  --   side_padding = 10,
  --   border = false,
  --   zindex = 1001,
  -- },
})

lsp.on_attach(function(client, bufnr)
  local opts = {buffer = bufnr, remap = false}

  vim.keymap.set("n", "gd", function() builtin.lsp_definitions() end, opts)
  vim.keymap.set("n", "gt", function() builtin.lsp_type_definitions() end, opts)
  vim.keymap.set("n", "gD", function() vim.lsp.buf.declaration() end, opts)
  vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)
  vim.keymap.set("n", "gi", function() builtin.lsp_implementations() end, opts)
  vim.keymap.set("n", "gr", function() builtin.lsp_references() end, opts)
  vim.keymap.set("n", "<leader>f", function() vim.lsp.buf.format() end, opts)
  vim.keymap.set("n", "ge", function() vim.diagnostic.show_line_diagnostics() end, opts)
  vim.keymap.set("n", "]e", function() vim.diagnostic.goto_next() end, opts)
  vim.keymap.set("n", "[e", function() vim.diagnostic.goto_prev() end, opts)
  vim.keymap.set("n", "<leader>rn", function() vim.lsp.buf.rename() end, opts)
  vim.keymap.set("n", "<leader>ga", function() vim.lsp.buf.code_action() end, opts)
end)

lsp.setup()


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


------------------------------------------------------------------
-- TASKWIKI                                                     --
------------------------------------------------------------------

local job = require('plenary.job')

function get_uuid(taskid, callback)
  job:new({
    command = 'task',
    args = { '_get', taskid .. '.uuid' },
    cwd = '/usr/bin',
    on_stderr = function(j, return_val)
      print("Error: " .. return_val)
    end,
    on_stdout = vim.schedule_wrap(function(j, uuid)
      callback(uuid)
    end),
  }):start()
end

function get_description(taskid, callback)
  job:new({
    command = 'task',
    args = { '_get', taskid .. '.description' },
    cwd = '/usr/bin',
    on_stderr = function(j, return_val)
      print("Error: " .. return_val)
    end,
    on_stdout = vim.schedule_wrap(function(j, desc)
      callback(desc)
    end),
  }):start()
end


function get_project_name(taskid, callback)
  job:new({
    command = 'task',
    args = { '_get', taskid .. '.project' },
    cwd = '/usr/bin',
    on_stderr = function(j, return_val)
      print("Error: " .. return_val)
    end,
    on_stdout = vim.schedule_wrap(function(j, project_name)
      callback(project_name)
    end),
  }):start()
end

function file_not_exist(dir, filename)
  local res = vim.fs.find(filename, { path = dir})
  return res[1] == nil
end

function create_taskwiki_file(full_path, uuid, callback)
  local create = vim.fn.input("File missing. Create file [y/N]: ", "")
  if not (create == "y") then
    print("File not created")
    return
  end
  print("Creating file")
  get_description(uuid, function(desc)
    local out = io.open(full_path, "w+")
    out:write("# " .. desc)
    out:close()
    callback()
  end)
end

function open_taskwiki_file(uuid) 
  get_project_name(uuid, function(project_name)
    local filename = uuid .. ".md"
    local dir = "/home/dghaehre/wikis/vimwiki/taskwarrior-notes/"
    if string.match(project_name, "%a+") == "vipps" then
      dir = "/home/dghaehre/wikis/work/taskwarrior-notes/"
    end
    local full_path = dir .. filename
    local res = vim.fs.find(filename, {
      path = dir,
    })
    if file_not_exist(dir, filename) then
      create_taskwiki_file(full_path, uuid, function()
        vim.api.nvim_command('e ' .. full_path)
      end)
      return
    end
    vim.api.nvim_command('e ' .. full_path)
  end)
end

function tnote()
  local linenr = vim.api.nvim_win_get_cursor(0)[1]
  local curline = vim.api.nvim_buf_get_lines(0, linenr - 1, linenr, false)[1]
  local taskid = string.match(curline, "#%w+", -10)
  if taskid == nil then
    print("Could not find taskwiki task")
    return nil
    else
      taskid = string.sub(taskid, 2)
  end
  get_uuid(taskid, function(uuid)
    open_taskwiki_file(uuid)
  end)
end

vim.keymap.set('n', '<Leader>tn', tnote)


------------------------------------------------------------------
-- Capture vimwiki
------------------------------------------------------------------


function capture_wiki(is_work)
  local header = vim.fn.input("Header: ", "")
  local filename = string.gsub(header, "%s+", "-") .. ".md"
  if is_work then
    filename = "/home/dghaehre/wikis/work/Inbox/" .. filename
  else
    filename = "/home/dghaehre/wikis/vimwiki/Inbox/" .. filename
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
