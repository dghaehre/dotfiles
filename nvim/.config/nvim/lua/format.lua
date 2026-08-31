-- Buffer formatting, bound to <leader>f.
--
-- Most filetypes go through the LSP. Markdown has no LSP formatter here, so
-- prose is reflowed with Neovim's built-in `gq`, which already knows about list
-- markers, hanging indents and block quotes (see $VIMRUNTIME/ftplugin/markdown.vim).
-- What it does not know about is fenced code blocks and pipe tables, so we ask
-- treesitter for the paragraph nodes and only ever format those.

local M = {}

local MARKDOWN_WIDTH = 80

-- `gq` with 'textwidth' 0 does not mean "unlimited", it means max(screen, 79).
-- Use a width no paragraph will reach so each one collapses onto a single line.
local UNWRAPPED_WIDTH = 100000

-- Options `gq` relies on. Set explicitly so the result is the same in vimwiki
-- buffers, which do not load the markdown ftplugin.
local gq_opts = {
  -- Hanging indent on wrapped list items must be spaces; a tab is read as four
  -- columns and makes the continuation line ambiguous.
  expandtab = true,
  formatoptions = "tcqln",
  comments = "fb:*,fb:-,fb:+,n:>",
  -- Long bracket is [==[ ]==]: the pattern itself contains ]].
  formatlistpat = [==[^\s*\d\+\.\s\+\|^\s*[-*+]\s\+\|^\[^\ze[^\]]\+\]:\&^.\{4\}]==],
}

local function paragraph_ranges(buf)
  local ok, parser = pcall(vim.treesitter.get_parser, buf, "markdown")
  if not ok or not parser then
    return nil
  end

  local tree = parser:parse()[1]
  local query = vim.treesitter.query.parse("markdown", "(paragraph) @para")

  local ranges = {}
  for _, node in query:iter_captures(tree:root(), buf) do
    local srow, _, erow, ecol = node:range()
    -- A paragraph swallows its trailing newline, so it ends at col 0 of the
    -- line after the text.
    if ecol == 0 then
      erow = erow - 1
    end
    table.insert(ranges, { srow + 1, erow + 1 })
  end
  return ranges
end

-- Reflow every markdown paragraph to `width`, leaving code fences, tables,
-- headings and html blocks alone.
local function reflow(width)
  local buf = vim.api.nvim_get_current_buf()
  local ranges = paragraph_ranges(buf)
  if not ranges then
    vim.notify("no markdown treesitter parser, cannot format", vim.log.levels.WARN)
    return
  end

  local view = vim.fn.winsaveview()
  local saved = {}
  for opt, value in pairs(gq_opts) do
    saved[opt] = vim.bo[buf][opt]
    vim.bo[buf][opt] = value
  end
  saved.textwidth = vim.bo[buf].textwidth
  vim.bo[buf].textwidth = width

  -- Bottom-up: reflowing changes the line count and would invalidate the range
  -- of every paragraph below the one being formatted.
  for i = #ranges, 1, -1 do
    local srow, erow = ranges[i][1], ranges[i][2]
    vim.cmd(("silent keepjumps normal! %dGgq%dG"):format(srow, erow))
  end

  for opt, value in pairs(saved) do
    vim.bo[buf][opt] = value
  end
  vim.fn.winrestview(view)
end

-- Collapse each paragraph onto one line. Used before handing text to renderers
-- that treat a single newline as a hard break rather than as a soft wrap
-- (Day One's dayone://post URL scheme does this) -- see bin/dayone-new.
function M.unwrap()
  reflow(UNWRAPPED_WIDTH)
end

function M.format()
  local ft = vim.bo.filetype
  if ft == "markdown" or ft == "vimwiki" then
    reflow(MARKDOWN_WIDTH)
  elseif ft == "swift" then
    vim.cmd("silent !swiftformat %")
    vim.cmd("checktime")
  else
    vim.lsp.buf.format()
  end
end

vim.keymap.set("n", "<leader>f", M.format, { desc = "Format buffer" })

return M
