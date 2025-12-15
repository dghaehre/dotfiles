-- LSP configuration

local lsp_configurations = require("lspconfig.configs")
local lspconfig = require("lspconfig")

require("mason-lspconfig").setup({
  ensure_installed = {},
  handlers = {
    function(server_name)
      lspconfig[server_name].setup({})
    end,
  },
})

local lsp = require("lsp-zero")

-- Janet LSP
-- sudo jpm install https://github.com/CFiggers/janet-lsp
if not lsp_configurations.janet_lsp then
  lsp_configurations.janet_lsp = {
    default_config = {
      name = "janet-lsp",
      cmd = { "janet-lsp" },
      filetypes = { "janet" },
      root_dir = lspconfig.util.root_pattern("project.janet"),
    },
  }
end
lspconfig.janet_lsp.setup({})

-- Gleam LSP
-- lspconfig.gleam.setup({})

-- Swift LSP
if not lsp_configurations.swift_lsp then
  lsp_configurations.swift_lsp = {
    default_config = {
      name = "swift-lsp",
      cmd = { vim.trim(vim.fn.system("xcrun -f sourcekit-lsp")) },
      filetypes = { "swift" },
      root_dir = lspconfig.util.root_pattern("buildServer.json"),
    },
  }
end
lspconfig.swift_lsp.setup({})

-- Xcode setup function (lazy loaded because it's slow)
function XcodeSetup()
  require("xcodebuild").setup({})
end
vim.keymap.set("n", "<leader>Xs", function()
  XcodeSetup()
end, { desc = "Run XcodeSetup" })

-- LSP on_attach keymaps
local builtin = require("telescope.builtin")

lsp.on_attach(function(client, bufnr)
  local opts = { buffer = bufnr, remap = false }

  vim.keymap.set("n", "gd", function()
    builtin.lsp_definitions()
  end, opts)
  vim.keymap.set("n", "gt", function()
    builtin.lsp_type_definitions()
  end, opts)
  vim.keymap.set("n", "gD", function()
    vim.lsp.buf.declaration()
  end, opts)
  vim.keymap.set("n", "K", function()
    vim.lsp.buf.hover()
  end, opts)
  vim.keymap.set("n", "gi", function()
    builtin.lsp_implementations()
  end, opts)
  vim.keymap.set("n", "gr", function()
    builtin.lsp_references()
  end, opts)
  vim.keymap.set("n", "<leader>f", function()
    if vim.bo.filetype == "swift" then
      vim.cmd("silent !swiftformat %")
    else
      vim.lsp.buf.format()
    end
  end, opts)
  vim.keymap.set("n", "ge", function()
    vim.diagnostic.show_line_diagnostics()
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
end)

lsp.setup()
