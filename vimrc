""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"   Filename: .vimrc                                                         "
" Maintainer: Felippe Nardi <felippe.dotfiles@nardi.me>                      "
"        URL: http://github.com/felippenardi/dotfiles                        "
"                                                                            "
"   Based_on: Michael J. Smalley <michaeljsmalley@gmail.com>                 "
"        URL: http://github.com/michaeljsmalley/dotfiles                     "
"                                                                            "
"                                                                            "
" Sections:                                                                  "
"   01. General ................. General Vim behavior                       "
"   02. Events .................. General autocmd events                     "
"   03. Theme/Colors ............ Colors, fonts, etc.                        "
"   04. Vim UI .................. User interface behavior                    "
"   05. Text Formatting/Layout .. Text, tab, indentation related             "
"   06. Custom Commands ......... Any custom command aliases                 "
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" 01. General                                                                "
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set nocompatible         " get rid of Vi compatibility mode. SET FIRST!
let mapleader = ","      " change default leader key
set history=1000         " Increase command history limit
set splitbelow           " Create new horizontal windows below
set splitright           " Create new horizontal windows to the right

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" 02. Events                                                                 "
" Initiate pathogen before enabling filetype detection
call pathogen#infect()
call pathogen#helptags()

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
filetype plugin indent on " filetype detection[ON] plugin[ON] indent[ON]

" In Makefiles DO NOT use spaces instead of tabs
autocmd FileType make setlocal noexpandtab
" In Ruby files, use 2 spaces instead of 4 for tabs
autocmd FileType ruby setlocal sw=2 ts=2 sts=2

" Enable omnicompletion (to use, hold Ctrl+X then Ctrl+O while in Insert mode.
set ofu=syntaxcomplete#Complete

" Enable spell check on commit message
autocmd BufNewFile,BufRead COMMIT_EDITMSG set spell

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" 03. Theme/Colors                                                           "
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set t_Co=256              " enable 256-color mode.
syntax enable             " enable syntax highlighting (previously syntax on).
"colorscheme Tomorrow-Night-Eighties       " set colorscheme
colorscheme Tomorrow                      " set colorscheme

" Prettify TODO files
autocmd BufRead,BufNewFile *.todo set filetype=todo
autocmd Syntax todo source ~/.vim/syntax/todo.vim

" Prettify Vagrantfile
autocmd BufRead,BufNewFile Vagrantfile set filetype=ruby

" Prettify Markdown files
"augroup markdown
"   au!
"  au BufNewFile,BufRead *.md,*.markdown setlocal filetype=ghmarkdown
"augroup END

" Highlight characters that go over 80 columns (by drawing a border on the 81st)
if exists('+colorcolumn')
  set colorcolumn=81
  highlight ColorColumn ctermbg=grey
else
  highlight OverLength ctermbg=red ctermfg=white guibg=#592929
  match OverLength /\%81v.\+/
endif

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" 04. Vim UI                                                                 "
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set number                " show line numbers
set numberwidth=2         " make the number gutter 6 characters wide
set cul                   " highlight current line
set laststatus=2          " last window always has a statusline
set nohlsearch            " Don't continue to highlight searched phrases.
set incsearch             " But do highlight as you type your search.
set ruler                 " Always show info along bottom.
set showmatch
set visualbell
let g:airline#extensions#tabline#enabled = 1 " Vim-airline smarter tab line

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" 05. Text Formatting/Layout                                                 "
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set autoindent            " auto-indent
set tabstop=2             " tab spacing
set softtabstop=2         " unify
set shiftwidth=2          " indent/outdent by 2 columns
set shiftround            " always indent/outdent to the nearest tabstop
set expandtab             " use spaces instead of tabs
set smartindent           " automatically insert one extra level of indentation
set smarttab              " use tabs at the start of a line, spaces elsewhere
set nowrap                " don't wrap text

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" 06. Custom Commands                                                        "
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""


nnoremap <ENTER> :w<ENTER>

" Easily create boxy characters for '0, 1, 3' scale
map ,m :s/0/▁/e<CR>:s/1/▅/e<CR>:s/3/▇/e<CR>:nohlsearch<cr>:echo <cr>

" Easily increase and decrease next number with ctrl+k and ctrl+j
nnoremap <C-k> <C-a>
nnoremap <C-j> <C-x>

" Enable paste respecting identation
set pastetoggle=<F2>


" Moving selection
xmap <C-k> :mo'<-- <CR> gv
xmap <C-j> :mo'>+ <CR> gv

function! ScreencastMode()
  GitGutterDisable
  set numberwidth=1
  set colorcolumn=810
endfunction

" Make Vim built-in explorer cool enough so I don't have to use NERDTree
" Toggle Vexplore with Ctrl-E
function! ToggleVExplorer()
  if exists("t:expl_buf_num")
      let expl_win_num = bufwinnr(t:expl_buf_num)
      if expl_win_num != -1
          let cur_win_nr = winnr()
          exec expl_win_num . 'wincmd w'
          close
          exec cur_win_nr . 'wincmd w'
          unlet t:expl_buf_num
      else
          unlet t:expl_buf_num
      endif
  else
      exec '1wincmd w'
      Vexplore
      let t:expl_buf_num = bufnr("%")
  endif
endfunction
map <silent> <C-E> :call ToggleVExplorer()<CR>
" Hit enter in the file browser to open the selected
" file with :vsplit to the right of the browser.
let g:netrw_browse_split = 4
let g:netrw_altv = 1
" Default to tree mode
let g:netrw_liststyle=3

" Quick cycle to next and previous buffer
nnoremap <S-Tab> gT
nnoremap <Tab> gt

" Quick Rename
function! RenameFile()
let old_name = expand('%:p')
let new_name = input('New file name: ', expand('%:p'), 'file')
if new_name != '' && new_name != old_name
    exec ':silent w'
    exec ':silent !mv ' . old_name . ' ' . new_name
    exec ':silent !git rm ' . old_name
    exec ':silent e ' . new_name
    exec ':silent bd ' . old_name
    redraw!
endif
endfunction
map <leader>n :call RenameFile()<cr>

" Make Ctrl+P skip .gitignore files
let g:ctrlp_user_command = ['.git/', 'git --git-dir=%s/.git ls-files -oc --exclude-standard']

" Avoid mistakenly closing window when willing to cancel ctrl+w with a " ctrl+c
map <c-w><c-c> <space>

" Copy and paste between different vim instances
map <leader>y :w! /tmp/vim-clipboard<cr>
map <leader>p :r /tmp/vim-clipboard<cr>
