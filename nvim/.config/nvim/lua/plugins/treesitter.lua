-- Treesitter configuration
local autocmd = vim.api.nvim_create_autocmd

local ts_parsers = {
  "bash",
  "c",
  "dockerfile",
  "fish",
  "git_config",
  "git_rebase",
  "gitattributes",
  "gitcommit",
  "gitignore",
  "go",
  "gomod",
  "gosum",
  "html",
  "javascript",
	-- "janet",
  "json",
  "lua",
  "make",
  "markdown",
  "python",
  "rust",
  "sql",
  "toml",
  "tsx",
  "typescript",
  "typst",
  "vim",
  "yaml",
  "zig",
}
local nts = require("nvim-treesitter")
nts.install(ts_parsers)
autocmd('PackChanged', { callback = function() nts.update() end })

local ok2, ts_context = pcall(require, "treesitter-context")
if ok2 then
  ts_context.setup({
    enable = true,
    max_lines = 1,
    trim_scope = "inner",
  })
end

autocmd("FileType", { -- enable treesitter highlighting and indents
	callback = function(args)
		local filetype = args.match
		local lang = vim.treesitter.language.get_lang(filetype)
		if vim.treesitter.language.add(lang) then
			vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
			vim.treesitter.start()
		end
	end
})
