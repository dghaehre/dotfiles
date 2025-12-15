-- Telescope configuration

local telescope = require("telescope")
local actions = require("telescope.actions")
local builtin = require("telescope.builtin")

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
        },
      },
    },
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
      fuzzy = true,
      override_generic_sorter = false,
      override_file_sorter = true,
      case_mode = "smart_case",
    },
  },
})

-- Load extensions
telescope.load_extension("git_worktree")
telescope.load_extension("fzf")
telescope.load_extension("dap")

local keymap = vim.keymap.set
local opts = { noremap = true, silent = true }

-- Git worktree
keymap("n", "<leader>gw", function()
  telescope.extensions.git_worktree.git_worktrees()
end, opts)

-- Find files
keymap("n", "<leader>sf", function()
  builtin.find_files()
end, opts)
keymap("n", "<leader>scf", function()
  builtin.find_files({ cwd = require("telescope.utils").buffer_dir(), hidden = true, no_ignore = true })
end, opts)
keymap("n", "<leader>scg", function()
  builtin.live_grep({ cwd = require("telescope.utils").buffer_dir(), hidden = true, no_ignore = true })
end, opts)

-- Search
keymap("n", "<leader>sg", function()
  builtin.live_grep()
end, opts)
keymap("n", "<leader>/", function()
  builtin.grep_string()
end, opts)

-- Buffers
keymap("n", "<leader>sbf", function()
  builtin.buffers()
end, opts)
keymap("n", "<leader>sbg", function()
  builtin.live_grep({ grep_open_files = true })
end, opts)

-- Misc
keymap("n", "<leader>sc", function()
  builtin.commands()
end, opts)
keymap("n", "<leader>so", function()
  builtin.oldfiles({ follow = true })
end, opts)
keymap("n", "<leader>sm", function()
  builtin.marks()
end, opts)
keymap("n", "<leader>sr", function()
  builtin.registers()
end, opts)
keymap("n", "<leader>=", function()
  builtin.spell_suggest()
end, opts)

-- Git
keymap("n", "<leader>cb", function()
  builtin.git_branches()
end, opts)
keymap("n", "<leader>cl", function()
  builtin.git_commits()
end, opts)

-- Vimwiki
keymap("n", "<leader>swf", function()
  builtin.find_files({ search_dirs = { "~/Library/Mobile Documents/com~apple~CloudDocs/vimwiki/" }, no_ignore = true })
end, opts)
keymap("n", "<leader>swtf", function()
  builtin.find_files({ search_dirs = { "~/wikis/vimwiki/taskwarrior-notes/" }, no_ignore = true })
end, opts)
keymap("n", "<leader>swtg", function()
  builtin.live_grep({ search_dirs = { "~/wikis/vimwiki/taskwarrior-notes/" } })
end, opts)
keymap("n", "<leader>swg", function()
  builtin.live_grep({ search_dirs = { "~/Library/Mobile Documents/com~apple~CloudDocs/vimwiki/" } })
end, opts)

-- Work wiki
keymap("n", "<leader>sjf", function()
  builtin.find_files({ search_dirs = { "~/wikis/work/" }, no_ignore = true })
end, opts)
keymap("n", "<leader>sjg", function()
  builtin.live_grep({ search_dirs = { "~/wikis/work/" } })
end, opts)
keymap("n", "<leader>sjtf", function()
  builtin.find_files({ search_dirs = { "~/wikis/work/taskwarrior-notes/" }, no_ignore = true })
end, opts)
keymap("n", "<leader>sjtg", function()
  builtin.live_grep({ search_dirs = { "~/wikis/work/taskwarrior-notes/" } })
end, opts)

-- Dotfiles
keymap("n", "<leader>sdf", function()
  builtin.find_files({ search_dirs = { "~/projects/personal/dotfiles" }, hidden = true, no_ignore = true })
end, opts)
keymap("n", "<leader>sdg", function()
  builtin.live_grep({ search_dirs = { "~/projects/personal/dotfiles" }, hidden = true, no_ignore = true })
end, opts)

-- Diagnostics and zoxide
keymap("n", "<leader>se", ":Telescope diagnostics<CR>", opts)
keymap("n", "<leader>scd", ":Telescope zoxide list<CR>", opts)

-- Vimwiki todos
keymap("n", "<leader>swt", function()
  builtin.grep_string({ search_dirs = { "~/wikis/vimwiki/" }, search = "- [ ]" })
end, opts)
keymap("n", "<leader>swx", function()
  builtin.grep_string({ search_dirs = { "~/wikis/vimwiki/" }, search = "- [X]" })
end, opts)

-- LSP telescope mappings
keymap("n", "gd", function()
  builtin.lsp_definitions()
end, opts)
keymap("n", "ged", function()
  builtin.lsp_definitions({ jump_type = "vsplit" })
end, opts)
keymap("n", "gtd", function()
  builtin.lsp_definitions({ jump_type = "tab" })
end, opts)
keymap("n", "gi", function()
  builtin.lsp_implementations()
end, opts)
keymap("n", "gI", function()
  builtin.lsp_implementations({ jump_type = "tab" })
end, opts)
keymap("n", "gr", function()
  builtin.lsp_references()
end, opts)
keymap("n", "gR", function()
  builtin.lsp_references({ jump_type = "tab" })
end, opts)
keymap("n", "<leader>ga", function()
  vim.lsp.buf.code_action()
end, opts)
