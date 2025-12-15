-- DAP (Debug Adapter Protocol) configuration

local ok, dap = pcall(require, "dap")
if not ok then
  return
end

local keymap = vim.keymap.set

keymap("n", "<leader>db", function()
  require("dap").toggle_breakpoint()
end)
keymap("n", "<leader>dc", function()
  require("dap").continue()
end)
keymap("n", "<leader>do", function()
  require("dap").step_over()
end)
keymap("n", "<leader>dO", function()
  require("dap").step_out()
end)
keymap("n", "<leader>di", function()
  require("dap").step_into()
end)
keymap("n", "<leader>dB", function()
  require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: "))
end)
keymap("n", "<leader>lp", function()
  require("dap").set_breakpoint(nil, nil, vim.fn.input("Log point message: "))
end)
keymap("n", "<leader>dr", function()
  require("dap").repl.open()
end)
keymap("n", "<leader>dt", function()
  require("dap-go").debug_test()
end)

require("dap-go").setup()

require("dapui").setup({
  mappings = {
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
        { id = "scopes", size = 0.50 },
        { id = "watches", size = 0.50 },
      },
      size = 40,
      position = "left",
    },
    {
      elements = {},
    },
  },
})

-- Open dap-ui when dap starts
local dapui = require("dapui")
dap.listeners.after.event_initialized["dapui_config"] = function()
  dapui.open()
end
dap.listeners.before.event_terminated["dapui_config"] = function()
  dapui.close()
end
dap.listeners.before.event_exited["dapui_config"] = function()
  dapui.close()
end
