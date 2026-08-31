-- Deferred plugin loading.
--
-- Plugins listed in the second vim.pack.add() call in lua/plugins.lua use
-- `load = function() end`, which makes vim.pack skip :packadd entirely
-- (vim/pack.lua:800) -- they are installed and registered, but never reach
-- 'runtimepath' at startup, so their plugin/ files are never sourced.
--
-- NOTE: `{ load = false }` does NOT achieve this. It is already the default
-- while init.lua is sourcing (vim/pack.lua:1006), so it still runs `packadd!`,
-- the plugin lands on 'runtimepath', and Neovim's normal startup pass sources
-- plugin/ anyway. A callable is the only thing that actually defers.
--
-- This module performs the packadd on first use.

local M = {}

local added = {}

--- Put a deferred plugin on 'runtimepath' and source its plugin/ files.
---
--- :packadd only sources plain plugin/ files, so after/plugin/ is sourced
--- explicitly -- mirroring what vim.pack does at vim/pack.lua:814. cmp-nvim-lsp
--- and cmp-buffer register their completion sources from after/plugin/ and are
--- silently inert without this.
---
--- @param name string Plugin directory name, e.g. "telescope.nvim"
function M.packadd(name)
  if added[name] then
    return
  end
  added[name] = true

  vim.cmd.packadd({ name, magic = { file = false } })

  local path
  for _, p in ipairs(vim.api.nvim_list_runtime_paths()) do
    if vim.fn.fnamemodify(p, ":t") == name then
      path = p
      break
    end
  end
  if not path then
    return
  end

  for _, file in ipairs(vim.fn.glob(path .. "/after/plugin/**/*.{vim,lua}", false, true)) do
    vim.cmd.source({ file, magic = { file = false } })
  end
end

--- packadd `packs` in order, then require `mod` for its configuration.
--- Idempotent; safe to call from every keymap and autocmd.
---
--- @param mod string Lua module holding the plugin's config
--- @param packs string[] Plugin directory names, in load order
function M.ensure(mod, packs)
  if package.loaded[mod] then
    return
  end
  for _, p in ipairs(packs) do
    M.packadd(p)
  end
  require(mod)
end

return M
