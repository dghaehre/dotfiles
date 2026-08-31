-- Harpoon configuration
--
-- harpoon is deferred (see lua/plugins.lua). This module only defines keymaps;
-- the plugin is packadd'ed and configured the first time one is pressed.

local lazyload = require("lazyload")

local configured = false

--- Load and configure harpoon on first use, then return it.
local function harpoon()
  if not configured then
    configured = true
    lazyload.packadd("harpoon")

    local ok, h = pcall(require, "harpoon")
    if not ok then return nil end

    h.setup({
      settings = {
        save_on_toggle = true,
      },
    })
  end

  local ok, h = pcall(require, "harpoon")
  if not ok then
    vim.notify("harpoon is not available", vim.log.levels.WARN)
    return nil
  end
  return h
end

local keymap = vim.keymap.set

keymap("n", "<leader>hh", function()
  local h = harpoon()
  if h then h:list():add() end
end)
keymap("n", "<leader>ho", function()
  local h = harpoon()
  if h then h.ui:toggle_quick_menu(h:list()) end
end)
keymap("n", "<leader>ha", function()
  local h = harpoon()
  if h then h:list():select(1) end
end)
keymap("n", "<leader>hs", function()
  local h = harpoon()
  if h then h:list():select(2) end
end)
keymap("n", "<leader>hd", function()
  local h = harpoon()
  if h then h:list():select(3) end
end)
keymap("n", "<leader>hf", function()
  local h = harpoon()
  if h then h:list():select(4) end
end)
keymap("n", "<leader>hk", function()
  local h = harpoon()
  if h then h:list():prev() end
end)
keymap("n", "<leader>hj", function()
  local h = harpoon()
  if h then h:list():next() end
end)
