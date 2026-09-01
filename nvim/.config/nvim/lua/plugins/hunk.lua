-- hunk.nvim configuration
--
-- hunk.nvim is only ever entered through :DiffEditor, which is how jj invokes
-- us as its external diff editor (see ui.diff-editor in jj/.config/jj/config.toml):
--
--   nvim -c "DiffEditor $left $right $output"
--
-- The plugin is deferred (see lua/plugins.lua); this stub packadds it the first
-- time the command runs. Upstream's plugin/hunk.lua defines its own DiffEditor
-- and replaces this one as soon as packadd sources it, so we call hunk.start()
-- directly instead of re-dispatching the command -- that also means no infinite
-- recursion if the packadd ever fails.

local lazyload = require("lazyload")

vim.api.nvim_create_user_command("DiffEditor", function(params)
  local args = params.fargs
  if #args < 2 then
    vim.notify("DiffEditor expects two or three arguments (left, right[, output])", vim.log.levels.ERROR)
    return
  end

  lazyload.packadd("hunk.nvim")

  local ok, hunk = pcall(require, "hunk")
  if not ok then
    vim.notify("hunk.nvim is not available", vim.log.levels.ERROR)
    return
  end

  -- setup() only merges overrides into the defaults; start() defines its own
  -- signs and highlights, so the defaults work without it. Add overrides here
  -- (keys, ui.layout, ui.tree.width, icons, ...) if the defaults ever chafe.
  hunk.setup({
    ui = {
      -- q exits via :cq, which makes jj discard the whole split. Worth a prompt.
      confirm_before_quit = true,
    },
  })

  hunk.start(args[1], args[2], args[3] or args[2])
end, {
  nargs = "*",
  desc = "Split diffs between two directories (hunk.nvim)",
})
