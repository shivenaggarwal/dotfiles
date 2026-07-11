-- kitty-default: mirrors kitty's built-in default terminal palette
-- https://sw.kovidgoyal.net/kitty/conf/#the-default-colors
--
-- Background/foreground/syntax colors come straight from kitty's ANSI
-- palette, since that's what the pane content sits on regardless of tmux.
-- UI chrome accents (statusline/tabline "current" highlight, popup select)
-- are pulled from ~/.tmux.conf's active status-bar colors: colour137
-- (#af875f, the tan that's actually visible throughout the tmux status
-- line) and colour234/237 greys, so nvim's own chrome doesn't clash with
-- the tmux status bar sitting right below it.

vim.cmd("hi clear")
if vim.fn.exists("syntax_on") == 1 then
  vim.cmd("syntax reset")
end
vim.o.background = "dark"
vim.g.colors_name = "kitty-default"

local c = {
  bg        = "#000000",
  bg1       = "#1c1c1c", -- tmux colour234 (status-bg)
  bg2       = "#3a3a3a", -- tmux colour237 (inactive-window bg)
  fg        = "#dddddd",
  fg_bright = "#ffffff",
  grey      = "#767676",
  cursor    = "#cccccc",
  sel_bg    = "#fffacd",
  sel_fg    = "#000000",

  -- tmux status-bar accent (from ~/.tmux.conf's active "original dark colors")
  accent = "#af875f", -- tmux colour137 (status-fg)

  black   = "#000000",
  red     = "#cc0403", red_br     = "#f2201f",
  green   = "#19cb00", green_br   = "#23fd00",
  yellow  = "#cecb00", yellow_br  = "#fffd00",
  blue    = "#0d73cc", blue_br    = "#1a8fff",
  magenta = "#cb1ed1", magenta_br = "#fd28ff",
  cyan    = "#0dcdcd", cyan_br    = "#14ffff",
}

local hi = function(group, opts)
  vim.api.nvim_set_hl(0, group, opts)
end

-- Editor UI
hi("Normal",       { fg = c.fg, bg = c.bg })
hi("NormalFloat",  { fg = c.fg, bg = c.bg })
hi("NormalNC",     { fg = c.fg, bg = c.bg })
hi("FloatBorder",  { fg = c.grey, bg = c.bg })
hi("Cursor",       { fg = c.bg, bg = c.cursor })
hi("CursorLine",   { bg = c.bg1 })
hi("CursorLineNr", { fg = c.accent, bold = true })
hi("LineNr",       { fg = c.grey })
hi("SignColumn",   { bg = "NONE" })
hi("FoldColumn",   { bg = "NONE", fg = c.grey })
hi("Folded",       { fg = c.grey, bg = c.bg1 })
hi("WinSeparator", { fg = c.grey, bg = "NONE" })
hi("VertSplit",    { fg = c.grey, bg = "NONE" })
hi("StatusLine",   { fg = c.fg, bg = c.bg2 })
hi("StatusLineNC", { fg = c.grey, bg = c.bg1 })
hi("Pmenu",        { fg = c.fg, bg = c.bg2 })
hi("PmenuSel",     { fg = c.black, bg = c.accent, bold = true })
hi("PmenuSbar",    { bg = c.bg2 })
hi("PmenuThumb",   { bg = c.grey })
hi("Visual",       { fg = c.sel_fg, bg = c.sel_bg })
hi("VisualNOS",    { fg = c.sel_fg, bg = c.sel_bg })
hi("Search",       { fg = c.black, bg = c.yellow })
hi("IncSearch",    { fg = c.black, bg = c.yellow_br })
hi("CurSearch",    { fg = c.black, bg = c.yellow_br })
hi("MatchParen",   { fg = c.fg_bright, bg = c.bg2, bold = true, underline = true })
hi("NonText",      { fg = c.grey })
hi("Whitespace",   { fg = c.bg2 })
hi("EndOfBuffer",  { fg = c.bg })
hi("Directory",    { fg = c.blue_br })
hi("Title",        { fg = c.blue_br, bold = true })
hi("ModeMsg",       { fg = c.fg })
hi("MoreMsg",       { fg = c.green_br })
hi("Question",      { fg = c.green_br })
hi("WarningMsg",    { fg = c.yellow_br })
hi("ErrorMsg",       { fg = c.fg_bright, bg = c.red, bold = true })

-- Diff
hi("DiffAdd",    { fg = c.green_br })
hi("DiffChange", { fg = c.yellow_br })
hi("DiffDelete", { fg = c.red_br })
hi("DiffText",   { fg = c.blue_br, bold = true })

-- Diagnostics
hi("DiagnosticError", { fg = c.red_br })
hi("DiagnosticWarn",  { fg = c.yellow_br })
hi("DiagnosticInfo",  { fg = c.blue_br })
hi("DiagnosticHint",  { fg = c.cyan_br })
hi("DiagnosticUnderlineError", { undercurl = true, sp = c.red_br })
hi("DiagnosticUnderlineWarn",  { undercurl = true, sp = c.yellow_br })
hi("DiagnosticUnderlineInfo",  { undercurl = true, sp = c.blue_br })
hi("DiagnosticUnderlineHint",  { undercurl = true, sp = c.cyan_br })

-- Classic syntax groups
hi("Comment",       { fg = c.grey, italic = true })
hi("Constant",      { fg = c.magenta })
hi("String",        { fg = c.green })
hi("Character",     { fg = c.green })
hi("Number",        { fg = c.magenta_br })
hi("Boolean",       { fg = c.magenta_br, bold = true })
hi("Float",         { fg = c.magenta_br })
hi("Identifier",    { fg = c.cyan })
hi("Function",      { fg = c.blue_br, bold = true })
hi("Statement",     { fg = c.yellow_br })
hi("Conditional",   { fg = c.yellow_br })
hi("Repeat",        { fg = c.yellow_br })
hi("Label",         { fg = c.yellow_br })
hi("Operator",      { fg = c.fg })
hi("Keyword",       { fg = c.red_br })
hi("Exception",     { fg = c.red_br, bold = true })
hi("PreProc",       { fg = c.blue })
hi("Include",       { fg = c.blue })
hi("Define",        { fg = c.blue })
hi("Macro",         { fg = c.blue })
hi("PreCondit",     { fg = c.blue })
hi("Type",          { fg = c.green_br })
hi("StorageClass",  { fg = c.green_br })
hi("Structure",     { fg = c.green_br })
hi("Typedef",       { fg = c.green_br })
hi("Special",       { fg = c.magenta_br })
hi("SpecialChar",   { fg = c.magenta_br })
hi("Tag",           { fg = c.red_br })
hi("Delimiter",     { fg = c.fg })
hi("SpecialComment",{ fg = c.grey, italic = true })
hi("Underlined",    { underline = true })
hi("Ignore",        { fg = c.grey })
hi("Error",         { fg = c.fg_bright, bg = c.red, bold = true })
hi("Todo",          { fg = c.black, bg = c.yellow_br, bold = true })

-- Treesitter (@) groups
hi("@variable",           { fg = c.fg })
hi("@variable.builtin",   { fg = c.red_br })
hi("@variable.parameter", { fg = c.fg, italic = true })
hi("@variable.member",    { fg = c.cyan })
hi("@constant",           { link = "Constant" })
hi("@constant.builtin",   { fg = c.magenta_br, bold = true })
hi("@string",             { link = "String" })
hi("@string.escape",      { fg = c.magenta_br })
hi("@number",             { link = "Number" })
hi("@boolean",            { link = "Boolean" })
hi("@function",           { link = "Function" })
hi("@function.builtin",   { fg = c.blue_br, italic = true })
hi("@function.call",      { link = "Function" })
hi("@function.method",    { link = "Function" })
hi("@function.method.call", { link = "Function" })
hi("@keyword",            { link = "Keyword" })
hi("@keyword.function",   { fg = c.red_br })
hi("@keyword.return",     { fg = c.red_br, bold = true })
hi("@keyword.operator",   { fg = c.red_br })
hi("@conditional",        { link = "Conditional" })
hi("@repeat",             { link = "Repeat" })
hi("@type",                { link = "Type" })
hi("@type.builtin",        { fg = c.green_br, italic = true })
hi("@property",             { fg = c.cyan })
hi("@field",                { fg = c.cyan })
hi("@parameter",            { fg = c.fg, italic = true })
hi("@comment",               { link = "Comment" })
hi("@punctuation.delimiter", { fg = c.fg })
hi("@punctuation.bracket",   { fg = c.fg })
hi("@punctuation.special",   { fg = c.magenta_br })
hi("@tag",              { link = "Tag" })
hi("@tag.attribute",    { fg = c.yellow_br, italic = true })
hi("@tag.delimiter",    { fg = c.grey })
hi("@operator",         { link = "Operator" })
hi("@module",           { fg = c.cyan })
hi("@namespace",        { fg = c.cyan })

-- mini.nvim
hi("MiniStatuslineModeNormal",  { fg = c.black, bg = c.accent, bold = true })
hi("MiniStatuslineModeInsert",  { fg = c.black, bg = c.green_br, bold = true })
hi("MiniStatuslineModeVisual",  { fg = c.black, bg = c.magenta_br, bold = true })
hi("MiniStatuslineModeReplace", { fg = c.black, bg = c.red_br, bold = true })
hi("MiniStatuslineModeCommand", { fg = c.black, bg = c.yellow_br, bold = true })
hi("MiniStatuslineDevinfo",     { fg = c.fg, bg = c.bg2 })
hi("MiniStatuslineFilename",    { fg = c.grey, bg = c.bg1 })
hi("MiniStatuslineFileinfo",    { fg = c.fg, bg = c.bg2 })
hi("MiniStatuslineInactive",    { fg = c.grey, bg = c.bg1 })

hi("MiniTablineCurrent",         { fg = c.black, bg = c.accent, bold = true })
hi("MiniTablineVisible",         { fg = c.fg, bg = c.bg2 })
hi("MiniTablineHidden",          { fg = c.grey, bg = c.bg1 })
hi("MiniTablineFill",            { bg = c.bg1 })
hi("MiniTablineModifiedCurrent", { fg = c.black, bg = c.yellow_br, bold = true })
hi("MiniTablineModifiedVisible", { fg = c.yellow_br, bg = c.bg2 })
hi("MiniTablineModifiedHidden",  { fg = c.yellow, bg = c.bg1 })
