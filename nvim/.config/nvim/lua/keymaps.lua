-- Key mappings (converted from vimrc)

local keymap = vim.keymap.set

-- Helper function for options
local opts = { noremap = true, silent = true }

-- Paste in visual mode without yanking
keymap("v", "P", '"_dP', opts)
-- Delete in visual mode without yanking
keymap("v", "D", '"_d', opts)

-- Copy/paste to system clipboard
keymap("n", "<leader>y", '"+y', opts)
keymap("v", "<leader>y", '"+y', opts)
keymap("n", "<leader>p", '"+p', opts)
keymap("v", "<leader>p", '"+p', opts)

-- Yank to end of line
keymap("n", "Y", "y$", opts)

-- Spelling
keymap("n", "<leader>zu", ":set spell spelllang=en_us<CR>", opts)
keymap("n", "<leader>zn", ":set spell spelllang=nb<CR>", opts)
keymap("n", "<leader>zz", ":set nospell<CR>", opts)

-- Change word, and press . for changing next word
keymap("n", "<leader>x", "*``cgn", opts)
keymap("v", "<leader>x", [[y/\V<C-R>=escape(@",'/\')<CR><CR>Ncgn]], opts)

-- Toggle indent highlight for tabs
keymap("n", "<leader>in", ":set invlist<CR>", opts)

-- Edit vimrc/init.lua
keymap("n", "<leader>qe", ":e ~/.config/nvim/init.lua<CR>", opts)
-- Source init.lua
keymap("n", "<leader>qs", ":source ~/.config/nvim/init.lua<CR>", opts)

-- Set current file as current dir
keymap("n", "<leader>cd", ":cd %:p:h<CR>:pwd<CR>", opts)

-- Open html file in firefox
keymap("n", "go", ":silent !firefox <cfile><CR>", opts)

-- Copy file path to register
keymap("n", "<leader>wp", ':let @" = expand("%")<CR>', opts)

-- Tests
keymap("n", "<leader>gt", ":TestNearest -strategy=neovim<CR>", { silent = true })
keymap("n", "<leader>gT", ":TestLast -strategy=neovim<CR>", { silent = true })
keymap("n", "<leader>gS", ":TestSuite -strategy=neovim<CR>", { silent = true })
keymap("n", "<leader>ht", ":TestVisit<CR>", { silent = true })
keymap("n", "<leader>gE", ":TestNearest -strategy=neovim EXPECT_OVERRIDE=true<CR>", { silent = true })

-- LF
keymap("n", "<leader>n", ":LfWorkingDirectory<CR>", opts)
keymap("n", "<leader>N", ":LfCurrentFile<CR>", opts)

-- NeoTree
keymap("n", "<leader>to", ":Neotree toggle focus<CR>", opts)
keymap("n", "<leader>tb", ":Neotree toggle focus buffers<CR>", opts)
keymap("n", "<leader>tg", ":Neotree toggle focus git_status<CR>", opts)

-- Git (gitgutter)
keymap("n", "]g", "<Plug>(GitGutterNextHunk)", {})
keymap("n", "[g", "<Plug>(GitGutterPrevHunk)", {})
keymap("n", "ga", "<Plug>(GitGutterStageHunk)", {})
keymap("v", "ga", "<Plug>(GitGutterStageHunk)", {})
keymap("n", "gu", "<Plug>(GitGutterUndoHunk)", {})

-- Lazygit
keymap("n", "<leader>lg", ":FloatermNew lazygit<CR>", opts)

-- Git (fugitive)
keymap("n", "<leader>gs", ":0G<CR>", opts)
keymap("n", "<leader>gb", ":Git blame<CR>", opts)
keymap("n", "<leader>gc", ":Git commit<CR>", opts)
keymap("n", "<leader>gp", ":! git push -u origin (git rev-parse --abbrev-ref HEAD)<CR>", opts)
keymap("n", "<leader>gP", ":! git push -u origin (git rev-parse --abbrev-ref HEAD) && gh pr create --web<CR>", opts)
keymap("n", "<leader>gl", ":0Gclog<CR>", opts)

-- Diffview
keymap("n", "<leader>gdo", ":DiffviewOpen ", { noremap = true })
keymap("n", "<leader>gdc", ":DiffviewClose<CR>", opts)
keymap("n", "<leader>gdt", ":DiffviewToggleFiles<CR>", opts)

-- Terminal
keymap("n", "<C-t>", ":b term:<CR>", opts)

-- Floaterm
keymap("n", "<C-f>", ":FloatermToggle<CR>", opts)
keymap("t", "<C-f>", [[<C-\><C-n>:FloatermToggle<CR>]], opts)
keymap("t", "<C-o>", [[<C-\><C-n>]], opts)
keymap("t", "<C-l>", [[<C-\><C-n>:FloatermNext<CR>]], opts)
keymap("t", "<C-h>", [[<C-\><C-n>:FloatermPrev<CR>]], opts)
-- keymap("t", "<C-u>", [[<C-\><C-n>:FloatermNew<CR>]], opts)

-- Navigation - toggle between buffers
keymap("n", "<leader><leader>", "<C-^>", opts)

-- Window navigation
keymap("n", "<C-j>", "<C-W><C-J>", opts)
keymap("n", "<C-k>", "<C-W><C-K>", opts)
keymap("n", "<C-l>", "<C-W><C-L>", opts)
keymap("n", "<C-h>", "<C-W><C-H>", opts)
keymap("n", "<leader>e", ":vsp<CR>", opts)
keymap("n", "<leader>E", ":sp<CR>", opts)

-- Tab navigation
keymap("n", "<leader><C-l>", ":tabnext<CR>", opts)
keymap("n", "<leader><C-h>", ":tabprev<CR>", opts)

-- Move lines up or down
keymap("n", "<C-u>", ":m .-2<CR>==", opts)
keymap("n", "<C-d>", ":m .+1<CR>==", opts)
keymap("v", "<C-u>", ":m '<-2<CR>gv=gv", opts)
keymap("v", "<C-d>", ":m '>+1<CR>gv=gv", opts)

-- Resizing
keymap("n", "<leader>rk", ":resize +20<CR>", opts)
keymap("n", "<leader>rj", ":resize -20<CR>", opts)
keymap("n", "<leader>rh", ":vertical resize +20<CR>", opts)
keymap("n", "<leader>rl", ":vertical resize -20<CR>", opts)

-- Copilot
keymap("n", "<leader>cod", ":Copilot disable<CR>", opts)
keymap("n", "<leader>coe", ":Copilot enable<CR>", opts)
keymap("v", "<leader>coe", ":CopilotChatExplain<CR>", opts)
keymap("n", "<leader>coc", ":CopilotChatToggle<CR>", opts)
keymap("n", "<leader>cor", ":CopilotChatReset<CR>", opts)
keymap("v", "<leader>cor", ":CopilotChatReview<CR>", opts)
keymap("v", "<leader>cof", ":CopilotChatFix<CR>", opts)

-- Vimwiki
keymap("v", "<leader>l", [[di[](<Esc>pa)<Esc>f[,a]], opts)
keymap("n", "<leader>tt", "<Plug>VimwikiToggleListItem", {})
keymap("n", "<leader>tj", "<Plug>VimwikiIncrementListItem", {})
keymap("v", "<leader>tj", "<Plug>VimwikiIncrementListItem", {})
keymap("n", "<leader>tk", "<Plug>VimwikiDecrementListItem", {})
keymap("v", "<leader>tk", "<Plug>VimwikiDecrementListItem", {})
keymap("n", "<leader>ta", ":VimwikiTable<CR>", opts)
keymap("n", "<leader>wb", ":VWB<CR>", opts)
-- Note: VimwikiFindAllIncompleteTasks and VimwikiFindIncompleteTasks functions were removed
-- Use telescope search for vimwiki todos instead (<leader>swt)

-- LSP (additional mappings not in lsp on_attach)
keymap("n", "<leader>ld", function() vim.diagnostic.open_float() end, opts)
keymap("n", "]e", function() vim.diagnostic.goto_next() end, opts)
keymap("n", "[e", function() vim.diagnostic.goto_prev() end, opts)
keymap("n", "<leader>lr", ":LspRestart<CR>", opts)
