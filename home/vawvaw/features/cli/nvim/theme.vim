if !has('gui_running') && &t_Co < 256
	finish
endif

set background=dark

hi clear
if exists('syntax_on')
	syntax reset
endif

let g:colors_name = 'jetbrains-high-contrast'

hi! LineNr						ctermfg=244

hi! PreProc						ctermfg=26
hi! Title	 						ctermfg=201
hi! Identifier 				ctermfg=6 cterm=none
hi! link StorageClass Statement
hi! Special 					ctermfg=5

hi! Constant					ctermfg=1
hi! Statement					ctermfg=130
hi! Function					ctermfg=136
hi! Comment						ctermfg=4
hi! Type 							ctermfg=2
hi! link Include			Type
hi! link Operator			Normal

" data types
hi! Number						ctermfg=39
hi! String						ctermfg=28
hi! link Boolean		 	Statement
hi! link Character		String


" nix
hi! nixAttribute			ctermfg=6
hi! link nixSimpleFunctionArgument nixAttribute
hi! link nixArgumentDefinition nixAttribute
hi! link nixInterpolationParam Special

" rust
hi! rustFuncName			ctermfg=226
hi! rustAttribute			ctermfg=136
hi! rustConstant			ctermfg=13
hi! link rustTrait		rustConstant

" python
hi! link pythonInclude	Statement
hi! link pythonOperator	Statement

" c
hi! link cInclude			Statement

" toml
hi! link tomlBoolean	Normal
hi! link tomlKey			Statement

" markdown
hi! markdownUrl				ctermfg=178
hi! link markdownCode	String

" css
hi! link cssProp			Type
