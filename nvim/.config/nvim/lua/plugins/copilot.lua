-- Copilot Chat configuration

require("CopilotChat").setup({})

function AskCopilotChat()
  local input = vim.fn.input("Quick Chat: ")
  if input ~= "" then
    require("CopilotChat").ask(input, { selection = require("CopilotChat.select").buffer })
  end
end

vim.keymap.set("n", "<leader>coq", function()
  AskCopilotChat()
end, { noremap = true })
