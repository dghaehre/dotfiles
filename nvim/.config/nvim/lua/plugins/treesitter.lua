-- Treesitter configuration

local ok, ts_configs = pcall(require, "nvim-treesitter.configs")
if not ok then return end

ts_configs.setup({
  ensure_installed = "all", -- one of "all", "maintained" (parsers with maintainers), or a list of languages
  ignore_install = { "ipkg" }, -- parsers to not install
  highlight = {
    enable = true,
  },
  indentation = {
    enable = false,
	},
  folding = {
    enable = true,
  },
})

local ok2, ts_context = pcall(require, "treesitter-context")
if ok2 then
  ts_context.setup({
    enable = true,
    max_lines = 1,
    trim_scope = "inner",
  })
end
