-- LSP configuration (Neovim 0.12+)

-- Mason for LSP server binary management
local ok, mason = pcall(require, "mason")
if ok then
  mason.setup({})
end

-- Custom LSP server configurations

-- Janet LSP
-- sudo jpm install https://github.com/CFiggers/janet-lsp
vim.lsp.config("janet_lsp", {
  cmd = { "janet-lsp" },
  filetypes = { "janet" },
  root_markers = { "project.janet", ".git" },
})

-- Enable LSP servers
-- Add mason-installed servers here (e.g. "lua_ls", "gopls", "ts_ls")
vim.lsp.enable({
  "janet_lsp",
	"gopls",
	"lua_ls",
})

-- Xcode setup function (lazy loaded because it's slow)
function XcodeSetup()
  require("xcodebuild").setup({})
end
vim.keymap.set("n", "<leader>Xs", function()
  XcodeSetup()
end, { desc = "Run XcodeSetup" })

vim.api.nvim_create_autocmd("FileType", {
  pattern = "swift",
  once = true,
  callback = function()
    vim.lsp.config("sourcekit", {
      cmd = { vim.trim(vim.fn.system("xcrun -f sourcekit-lsp")) },
      filetypes = { "swift" },
      root_markers = { ".swiftformat", ".git" },
    })
    vim.lsp.enable("sourcekit")
  end,
})

-- LSP keymaps via LspAttach autocmd
local function telescope_builtin(name)
  return function()
    require("telescope.builtin")[name]()
  end
end

vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local opts = { buffer = args.buf, remap = false }

    vim.keymap.set("n", "gd", telescope_builtin("lsp_definitions"), opts)
    vim.keymap.set("n", "gt", telescope_builtin("lsp_type_definitions"), opts)
    vim.keymap.set("n", "gD", function()
      vim.lsp.buf.declaration()
    end, opts)
    vim.keymap.set("n", "K", function()
      vim.lsp.buf.hover()
    end, opts)
    vim.keymap.set("n", "gi", telescope_builtin("lsp_implementations"), opts)
    vim.keymap.set("n", "gr", telescope_builtin("lsp_references"), opts)
    vim.keymap.set("n", "<leader>f", function()
      if vim.bo.filetype == "swift" then
        vim.cmd("silent !swiftformat %")
      else
        vim.lsp.buf.format()
      end
    end, opts)
    vim.keymap.set("n", "ge", function()
      vim.diagnostic.open_float()
    end, opts)
    vim.keymap.set("n", "]e", function()
      vim.diagnostic.goto_next()
    end, opts)
    vim.keymap.set("n", "[e", function()
      vim.diagnostic.goto_prev()
    end, opts)
    vim.keymap.set("n", "<leader>rn", function()
      vim.lsp.buf.rename()
    end, opts)
    vim.keymap.set("n", "<leader>ga", function()
      vim.lsp.buf.code_action()
    end, opts)
  end,
})
