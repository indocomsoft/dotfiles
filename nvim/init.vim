"" GENERAL
" Dark background mode
set background=dark

" Use 2 spaces
set tabstop=2
set softtabstop=0
set shiftwidth=2
" Expand tabs into spaces
set expandtab

" Autoread
set autoread

" Highlight searches
set hlsearch

" Add line marker at 81th character
set cc=81

" Show line numbers
set number

" Show partial commands on bottom right
set showcmd

" Set undo files and backup files in ~/.vimtmp
set undofile backup
set backupdir=~/.vimtmp,.
set directory=~/.vimtmp,.
set undodir=~/.vimtmp,.

" Disable mouse
set mouse=

" Set F3 as paste toggle
set pastetoggle=<F3>

" On `:set list` show tab with >·
set list listchars=tab:\|\ ,trail:·

" Use \ as local leader, for LaTeX (HALP)
let maplocalleader='\'

" Map Ctrl+H to :noh (:nohlsearch)
nnoremap <C-h> :noh<CR>

"" PLUGINS
call plug#begin()
" Use sensible defaults
Plug 'tpope/vim-sensible'
" Pretty status line
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
" Git things
Plug 'tpope/vim-fugitive'
" Show git diff in gutter
Plug 'airblade/vim-gitgutter'
" Auto close parantheses
Plug 'jiangmiao/auto-pairs'
" Syntax checkers
Plug 'scrooloose/syntastic'
" File browser in sidebar
Plug 'scrooloose/nerdtree'
" Code formatter
Plug 'google/vim-codefmt'
Plug 'google/vim-maktaba'
Plug 'google/vim-glaive'
" Tags
" Plug 'xolox/vim-easytags'
" Plug 'xolox/vim-misc'
" Plug 'indocomsoft/taglist.vim'
Plug 'majutsushi/tagbar'
" LaTeX
" Plug 'lervag/vimtex'
" Rails stuff
Plug 'tpope/vim-rails'
Plug 'tpope/vim-bundler'
" Javascript stuff
Plug 'pangloss/vim-javascript'
" Plug 'mxw/vim-jsx'
" Elixir stuff
Plug 'elixir-editors/vim-elixir'
" Prettier
Plug 'prettier/vim-prettier', { 'do': 'yarn install' }
" Typescript stuff
Plug 'leafgarland/typescript-vim'
" Plug 'ianks/vim-tsx'
" Plug 'peitalin/vim-jsx-typescript'
" Plug 'mhartington/nvim-typescript', { 'do': './install.sh' }
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
let g:deoplete#enable_at_startup = 1
" Swift stuffs
Plug 'keith/swift.vim'

Plug 'slashmili/alchemist.vim'

Plug 'wlangstroth/vim-racket'

Plug 'neovimhaskell/haskell-vim'

Plug 'rust-lang/rust.vim'

Plug 'indocomsoft/vim-x10'

call plug#end()
"" vim-airline
let g:airline_powerline_fonts = 1

"" SYNTASTIC - Syntax Checker
" These defaults are from Syntastic
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_loc_list_height = 3
let g:syntastic_mode_map = {
  \ "mode": "passive",
  \ "active_filetypes": [],
  \ "passive_filetypes": [] }
" Map Ctrl+C to check syntax and Ctrl+Alt+C to remove syntax checker
nnoremap <C-c> :SyntasticCheck<CR>
nnoremap <C-A-c> :SyntasticReset<CR>

" Syntastic Checkers
let g:syntastic_python_checkers = ['flake8']
let g:syntastic_ruby_checkers = ['rubocop']
let g:syntastic_javascript_checkers = ['eslint']
let g:syntastic_javascript_eslint_exec = 'node_modules/.bin/eslint'
" let g:syntastic_typescript_checkers = ['tslint']
let g:syntastic_haml_checkers = ['haml_lint']
let g:syntastic_scss_checkers = ['scss_lint']
let g:syntastic_swift_checkers = ['swiftpm', 'swiftlint']



" let g:syntastic_enable_elixir_checker = 1
" let g:syntastic_elixir_checkers = ['elixir']

"" NERDTREE - file browser in sidebar
" Enter NERDTree on start if no argument
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif
" Close if the only window left is NERDTree
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
" Ignore pyc files
let NERDTreeIgnore = ['\.pyc$']
" Toggle NERDTree with Ctrl+N
map <C-n> :NERDTreeToggle<CR>

"" Taglist
" nnoremap <C-t> :TlistToggle<CR>:TlistUpdate<CR>
" let Tlist_Use_Right_Window = 1
nnoremap tt :TagbarToggle<CR>

" Code Formatter
call glaive#Install()
" Enable codefmt's default mappings on the <Leader>= prefix.
Glaive codefmt plugin[mappings]
" google-java-format location
Glaive codefmt google_java_executable="java -jar /home/julius/.config/nvim/google-java-format-1.6-SNAPSHOT-all-deps-disable-one-line.jar --skip-removing-unused-imports"
Glaive codefmt clang_format_style="webkit"
" Automatically format codes
augroup autoformat_settings
  autocmd FileType java AutoFormatBuffer google-java-format
  autocmd FileType python AutoFormatBuffer yapf
  autocmd FileType c,cpp,cuda AutoFormatBuffer clang-format
augroup END

"" LANGUAGE-SPECIFIC

" Javascript: Allow JSX in normal JS files and use 4 spaces
let g:syntastic_swift_checkers = ['swiftpm', 'swiftlint']
" autocmd FileType javascript setlocal shiftwidth=4 tabstop=4

autocmd FileType c,cpp,cuda setlocal shiftwidth=4 tabstop=4

autocmd BufWritePost *.rb silent execute '!rubocop -a %' | redraw!

" LaTeX: default latexmk options for vimtex
"let g:vimtex_latexmk_options = '-pdf -shell-escape -verbose -file-line-error -synctex=1 -interaction=nonstopmode'
" let g:vimtex_compiler_latexmk = {
" \  'options': ['-verbose', '-file-line-error', '-synctex=1', '-interaction=nonstopmode', '-shell-escape'],
" \  'continuous': 1
" \}
" let g:vimtex_compiler_progname = 'nvr'

" Python: don't use PEP8 recommendation of 4 spaces
" let g:python_recommended_style = 0

" Swift: use 4 spaces
autocmd FileType swift setlocal shiftwidth=4 tabstop=4

" Typescript: linebreak at 100 chars and use ES2015
" autocmd FileType typescript setlocal cc=101
let g:typescript_compiler_options = '--target ES6'
autocmd BufEnter *.tsx set filetype=typescript.tsx

" Java: got this from StackOverflow, set make to javac
autocmd Filetype java set makeprg=javac\ %:S
set errorformat=%A%f:%l:\ %m,%-Z%p^,%-C%.%#

nmap <C-g> <Plug>(grammarous-open-info-window)


"" NEOVIM
" Escape terminal
tnoremap <esc> <C-\><C-n>

" No number in terminal
au TermOpen * setlocal nonumber norelativenumber

" Treat long lines as break lines
map j gj
map k gk

"" Tags for unsupported languages
" Elixir
let g:tagbar_type_elixir = {
    \ 'ctagstype' : 'elixir',
    \ 'kinds' : [
        \ 'f:functions',
        \ 'functions:functions',
        \ 'c:callbacks',
        \ 'd:delegates',
        \ 'e:exceptions',
        \ 'i:implementations',
        \ 'a:macros',
        \ 'o:operators',
        \ 'm:modules',
        \ 'p:protocols',
        \ 'r:records',
        \ 't:tests'
    \ ]
\ }

" Rust
let g:tagbar_type_rust = {
   \ 'ctagstype' : 'rust',
   \ 'kinds' : [
       \'T:types,type definitions',
       \'f:functions,function definitions',
       \'g:enum,enumeration names',
       \'s:structure names',
       \'m:modules,module names',
       \'c:consts,static constants',
       \'t:traits',
       \'i:impls,trait implementations',
   \]
   \}
