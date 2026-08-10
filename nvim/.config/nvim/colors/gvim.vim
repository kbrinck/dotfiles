" ============================================================================
" Classic GVim Light
" ============================================================================
"
" Reproduces the classic Vim/GVim light syntax palette using the actual
" RGB values reported by GVim 9.2.
"
" GVim palette:
"
"   Comment     #0000ff  Blue
"   Constant    #ff00ff  Magenta
"   Special     #6a5acd  SlateBlue
"   Identifier  #008b8b  DarkCyan
"   Statement   #a52a2a  Brown
"   PreProc     #6a0dad
"   Type        #2e8b57  SeaGreen
"
" ============================================================================

highlight clear

if exists("syntax_on")
    syntax reset
endif

let g:colors_name = "gvim"

set background=light

" ============================================================================
" Basic display
" ============================================================================

highlight Normal       guifg=#000000 guibg=#ffffff
highlight NormalNC     guifg=#000000 guibg=#ffffff
highlight NonText      guifg=#0000ff guibg=#ffffff
highlight EndOfBuffer  guifg=#0000ff guibg=#ffffff

" ============================================================================
" Cursor and selection
" ============================================================================

highlight Cursor       guifg=#ffffff guibg=#000000
highlight lCursor      guifg=#ffffff guibg=#000000
highlight CursorIM     guifg=#ffffff guibg=#000000

highlight Visual       guifg=#ffffff guibg=#008b8b
highlight VisualNOS    guifg=#ffffff guibg=#008b8b

highlight Search       guifg=#000000 guibg=#ffff00
highlight IncSearch   guifg=#ffffff guibg=#8b0000
highlight CurSearch   guifg=#ffffff guibg=#8b0000
highlight MatchParen   guifg=#ffffff guibg=#008b8b

" ============================================================================
" Status line and window separators
" ============================================================================

highlight StatusLine   guifg=#ffffff guibg=#00008b gui=bold
highlight StatusLineNC guifg=#000000 guibg=#d3d3d3
highlight VertSplit    guifg=#808080 guibg=#ffffff
highlight WinSeparator guifg=#808080 guibg=#ffffff

highlight TabLine      guifg=#000000 guibg=#d3d3d3
highlight TabLineFill  guifg=#808080 guibg=#d3d3d3
highlight TabLineSel   guifg=#ffffff guibg=#00008b gui=bold

" ============================================================================
" Line numbers, folds and columns
" ============================================================================

highlight LineNr       guifg=#a52a2a guibg=#ffffff
highlight CursorLineNr guifg=#a52a2a guibg=#ffffff gui=bold

highlight SignColumn   guifg=#008b8b guibg=#ffffff
highlight FoldColumn   guifg=#008b8b guibg=#ffffff

highlight Folded       guifg=#00008b guibg=#d3d3d3

highlight ColorColumn  guifg=#000000 guibg=#d3d3d3

highlight CursorLine   guibg=#ffffe0
highlight CursorColumn guibg=#ffffe0

" ============================================================================
" Messages
" ============================================================================

highlight ErrorMsg     guifg=#ffffff guibg=#ff0000
highlight WarningMsg   guifg=#ff0000 guibg=#ffffff
highlight MoreMsg      guifg=#006400 guibg=#ffffff
highlight ModeMsg      guifg=#006400 guibg=#ffffff gui=bold
highlight Question     guifg=#006400 guibg=#ffffff
highlight Title        guifg=#a52a2a guibg=#ffffff gui=bold

" ============================================================================
" Completion menus
" ============================================================================

highlight Pmenu        guifg=#000000 guibg=#d3d3d3
highlight PmenuSel     guifg=#ffffff guibg=#00008b
highlight PmenuSbar    guifg=#000000 guibg=#808080
highlight PmenuThumb   guifg=#ffffff guibg=#808080

highlight WildMenu     guifg=#000000 guibg=#ffff00

highlight Directory    guifg=#008b8b guibg=#ffffff gui=bold
highlight Conceal      guifg=#808080 guibg=#ffffff

" ============================================================================
" Diff
" ============================================================================

highlight DiffAdd      guifg=#006400 guibg=#90ee90
highlight DiffChange   guifg=#00008b guibg=#add8e6
highlight DiffDelete   guifg=#8b0000 guibg=#ffb6c1
highlight DiffText     guifg=#000000 guibg=#ffff00 gui=bold

" ============================================================================
" Spelling
" ============================================================================

highlight SpellBad     guifg=#ff0000 guibg=#ffffff gui=undercurl
highlight SpellCap     guifg=#0000ff guibg=#ffffff gui=undercurl
highlight SpellLocal   guifg=#008b8b guibg=#ffffff gui=undercurl
highlight SpellRare    guifg=#ff00ff guibg=#ffffff gui=undercurl

" ============================================================================
" Classic GVim syntax palette
" ============================================================================

highlight Comment      term=bold guifg=#0000ff
highlight Constant                 guifg=#ff00ff
highlight Special                  guifg=#6a5acd
highlight Identifier               guifg=#008b8b
highlight Statement   gui=bold     guifg=#a52a2a
highlight PreProc                  guifg=#6a0dad
highlight Type        gui=bold     guifg=#2e8b57

" ============================================================================
" Constant derivatives
" ============================================================================

highlight String                   guifg=#ff00ff
highlight Character                guifg=#ff00ff
highlight Number                   guifg=#ff00ff
highlight Boolean                  guifg=#ff00ff
highlight Float                    guifg=#ff00ff

" ============================================================================
" Special derivatives
" ============================================================================

highlight SpecialChar              guifg=#6a5acd
highlight Tag                      guifg=#6a5acd
highlight Delimiter                guifg=#6a5acd
highlight SpecialComment           guifg=#6a5acd
highlight Debug                    guifg=#6a5acd

" ============================================================================
" Statement derivatives
" ============================================================================

highlight Conditional gui=bold     guifg=#a52a2a
highlight Repeat      gui=bold     guifg=#a52a2a
highlight Label       gui=bold     guifg=#a52a2a
highlight Operator    gui=bold     guifg=#a52a2a
highlight Keyword     gui=bold     guifg=#a52a2a
highlight Exception   gui=bold     guifg=#a52a2a

" ============================================================================
" Preprocessor derivatives
" ============================================================================

highlight Include                  guifg=#6a0dad
highlight Define                   guifg=#6a0dad
highlight Macro                    guifg=#6a0dad
highlight PreCondit                guifg=#6a0dad

" ============================================================================
" Type derivatives
" ============================================================================

highlight StorageClass gui=bold    guifg=#2e8b57
highlight Structure    gui=bold    guifg=#2e8b57
highlight Typedef      gui=bold    guifg=#2e8b57

" ============================================================================
" Other standard syntax groups
" ============================================================================

highlight Underlined               guifg=#0000ff gui=underline
highlight Ignore                   guifg=#ffffff
highlight Todo        gui=bold     guifg=#000000 guibg=#ffff00
highlight Error       gui=bold     guifg=#ffffff guibg=#ff0000

" ============================================================================
" Links
" ============================================================================

highlight link Character       Constant
highlight link String          Constant
highlight link Number          Constant
highlight link Boolean         Constant
highlight link Float           Constant

highlight link Conditional     Statement
highlight link Repeat          Statement
highlight link Label           Statement
highlight link Operator        Statement
highlight link Keyword         Statement
highlight link Exception       Statement

highlight link Include         PreProc
highlight link Define          PreProc
highlight link Macro           PreProc
highlight link PreCondit       PreProc

highlight link StorageClass    Type
highlight link Structure       Type
highlight link Typedef         Type

highlight link SpecialChar     Special
highlight link Tag             Special
highlight link Delimiter       Special
highlight link SpecialComment  Special
highlight link Debug           Special
"
" ============================================================
" Treesitter highlight groups
" Approximate classic GVim colours
" ============================================================

" Comments
hi! @comment guifg=#0000ff

" Constants / literals
hi! @constant guifg=#ff00ff
hi! @constant.builtin guifg=#ff00ff
hi! @number guifg=#ff00ff
hi! @boolean guifg=#ff00ff

" Variables / identifiers
hi! @variable guifg=#000000
hi! @variable.builtin guifg=#008b8b
hi! @variable.parameter guifg=#008b8b
hi! @variable.member guifg=#008b8b
hi! @property guifg=#008b8b

" Functions
hi! @function guifg=#008b8b
hi! @function.call guifg=#008b8b
hi! @function.builtin guifg=#008b8b
hi! @method guifg=#008b8b
hi! @method.call guifg=#008b8b

" Keywords / statements
hi! @keyword guifg=#a52a2a
hi! @keyword.function guifg=#a52a2a
hi! @keyword.return guifg=#a52a2a
hi! @keyword.operator guifg=#a52a2a
hi! @conditional guifg=#a52a2a
hi! @repeat guifg=#a52a2a
hi! @exception guifg=#a52a2a

" Types
hi! @type guifg=#2e8b57
hi! @type.builtin guifg=#2e8b57

" Preprocessor / attributes
hi! @attribute guifg=#6a0dad
hi! @module guifg=#6a0dad

" Strings
hi! @string guifg=#ff00ff
hi! @string.escape guifg=#6a5acd
hi! @character guifg=#ff00ff

" Operators
hi! @operator guifg=#a52a2a

" Punctuation
hi! @punctuation.delimiter guifg=#000000
hi! @punctuation.bracket guifg=#000000

" Labels / constructors
hi! @label guifg=#a52a2a
hi! @constructor guifg=#2e8b57
