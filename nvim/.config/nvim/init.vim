set rtp^=/usr/share/vim/vimfiles/
set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath = &runtimepath
" set termguicolors
source ~/.vimrc

" lsp for neovim
lua << EOF
local nvim_lsp = require('lspconfig')
local job = require('plenary.job')

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

  -- Enable completion triggered by <c-x><c-o>
  -- buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')
  vim.lsp.set_log_level("debug")

  -- Mappings.
  local opts = { noremap=true, silent=true }


  -- See `:help vim.lsp.*` for documentation on any of the below functions
  buf_set_keymap('n', 'gD', '<Cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  buf_set_keymap('n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
  buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  buf_set_keymap("n", "<space>f", "<cmd>lua vim.lsp.buf.format()<CR>", opts)
  buf_set_keymap('n', 'ge', '<cmd>lua vim.diagnostic.show_line_diagnostics()<CR>', opts)
  buf_set_keymap('n', '[e', '<cmd>lua vim.diagnostic.goto_prev()<CR>', opts)
  buf_set_keymap('n', ']e', '<cmd>lua vim.diagnostic.goto_next()<CR>', opts)
  buf_set_keymap('n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)

end

-- Use a loop to conveniently call 'setup' on multiple servers and
-- map buffer local keybindings when the language server attaches
local servers = { "gopls", "rust_analyzer", "tsserver", "hls", "pyright", "racket_langserver" }
for _, lsp in ipairs(servers) do
  nvim_lsp[lsp].setup {
    on_attach = on_attach,
    flags = {
      debounce_text_changes = 150,
    }
  }
end

-- Debugging setup (dap)
local ok, dap = pcall(require, "dap")
if ok then
  vim.keymap.set("n", "<F5>", ":lua require'dap'.continue()<CR>")
  vim.keymap.set("n", "<F3>", ":lua require'dap'.step_over()<CR>")
  vim.keymap.set("n", "<F2>", ":lua require'dap'.step_into()<CR>")
  vim.keymap.set("n", "<F12>", ":lua require'dap'.step_out()<CR>")
  vim.keymap.set("n", "<leader>b", ":lua require'dap'.toggle_breakpoint()<CR>")
  vim.keymap.set("n", "<leader>B", ":lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>")
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

-- comp setup

local cmp = require('cmp')
cmp.setup {
  -- snippet = {
  --   -- REQUIRED - you must specify a snippet engine
  --   expand = function(args)
  --     -- vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
  --     -- require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
  --     -- require('snippy').expand_snippet(args.body) -- For `snippy` users.
  --     -- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
  --   end,
  -- },
  mapping = {
    ['<C-y>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), { 'i', 'c' }),
    ['<C-e>'] = cmp.mapping(cmp.mapping.scroll_docs(4), { 'i', 'c' }),
    ['<C-j>'] = cmp.mapping(cmp.mapping.select_next_item()),
    ['<C-k>'] = cmp.mapping(cmp.mapping.select_prev_item()),
    ['<C-l>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
    ['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }),
    -- ['<C-y>'] = cmp.config.disable, -- Specify `cmp.config.disable` if you want to remove the default `<C-y>` mapping.
    ['<C-f>'] = cmp.mapping({
      i = cmp.mapping.abort(),
      c = cmp.mapping.close(),
    }),
  },
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    -- { name = 'vsnip' }, -- For vsnip users.
    -- { name = 'luasnip' }, -- For luasnip users.
    -- { name = 'ultisnips' }, -- For ultisnips users.
    -- { name = 'snippy' }, -- For snippy users.
  }, {
    { name = 'buffer' },
    { name = 'path' },
  })
}



-- TELESCOPE
local actions = require('telescope.actions')
require('telescope').setup{
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
}
require('telescope').load_extension('fzf')
require('telescope').load_extension('dap')

-- Treesitter
require'nvim-treesitter.configs'.setup {
  ensure_installed = "all",
  highlight = {
    enable = true,              -- false will disable the whole extension
  },
  indentation = {
    enable = true,              -- false will disable the whole extension
  },
  folding = {
    enable = true,              -- false will disable the whole extension
  },
}

-- Comment.nvim
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

------------------------------------------------------------
--   TASKWIKI                                             --
------------------------------------------------------------

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

EOF
