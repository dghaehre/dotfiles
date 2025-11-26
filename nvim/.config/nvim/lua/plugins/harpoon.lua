-- Harpoon configuration

local harpoon = require("harpoon")

harpoon.setup({
  settings = {
    save_on_toggle = true,
  },
})

local keymap = vim.keymap.set

keymap("n", "<leader>hh", function()
  harpoon:list():add()
end)
keymap("n", "<leader>ho", function()
  harpoon.ui:toggle_quick_menu(harpoon:list())
end)
keymap("n", "<leader>ha", function()
  harpoon:list():select(1)
end)
keymap("n", "<leader>hs", function()
  harpoon:list():select(2)
end)
keymap("n", "<leader>hd", function()
  harpoon:list():select(3)
end)
keymap("n", "<leader>hf", function()
  harpoon:list():select(4)
end)
keymap("n", "<leader>hk", function()
  harpoon:list():prev()
end)
keymap("n", "<leader>hj", function()
  harpoon:list():next()
end)
