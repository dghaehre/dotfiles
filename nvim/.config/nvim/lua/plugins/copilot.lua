-- Copilot Chat configuration

require("CopilotChat").setup({
  model = "claude-sonnet-4.5", -- AI model to use
})

function AskCopilotChat()
  local input = vim.fn.input("Quick Chat: ")
  if input ~= "" then
    require("CopilotChat").ask(input, { selection = require("CopilotChat.select").buffer })
  end
end

vim.keymap.set("n", "<leader>coq", function()
  AskCopilotChat()
end, { noremap = true })
