" Todo list syntax file

if exists("b:current_syntax")
  finish
endif

syn match date  ".*, \d.*:"
syn match goal  ".*GOAL.*\d\d.*:"
syn match week  "^Week.*$"
syn match day  "^Day.*$"
syn match header  ".*:$"
syn match timeinterval "\s\+\d\+[hmd]\s"
syn match projectKeyword "^Proj\s\+"
syn region project matchgroup=projectKeyword start="^Proj\s\+" end="\s\+"

syn match null  "_"
syn match fail "▁"
syn match semiwin "▅"
syn match win "▇"

highlight link date   Comment
highlight link week   Invisible
highlight link day   Invisible
highlight link timeinterval Comment
highlight link goal   Comment
highlight link header   Type
highlight link project  Type

highlight link null   Invisible
highlight link fail   vimCommand
highlight link semiwin    Operator
highlight link win    Type
