
local ok, _99 = pcall(require, "99")
if not ok then return end
_99.setup({
	provider = _99.Providers.CursorAgentProvider,
	source = "cmp",
})

vim.keymap.set("v", "<leader>9v", function()
	_99.visual()
end)

vim.keymap.set("n", "<leader>9x", function()
	_99.stop_all_requests()
end, { noremap = true })

vim.keymap.set("n", "<leader>9s", function()
	_99.search()
end, { noremap = true })

vim.keymap.set("n", "<leader>9m", function()
  require("99.extensions.telescope").select_model()
end)

vim.keymap.set("n", "<leader>9p", function()
  require("99.extensions.telescope").select_provider()
end)
