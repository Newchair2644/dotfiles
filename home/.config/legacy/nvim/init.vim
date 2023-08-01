" add some optional plugins
if has('nvim')
	packadd which-key.nvim
endif
if has('python3')
	packadd ultisnips
endif

autocmd filetype c packadd nvim-lspconfig

" Colorscheme
colorscheme base16
set termguicolors

" General {{{1
let mapleader =" "
set ignorecase smartcase
filetype plugin on
syntax on
set encoding=utf-8
set mouse=nv
set hidden
set splitbelow splitright
set termguicolors
" 1}}}

" Editing {{{1
" highlight line with cursor
set cursorline
" highlight column 110 (guide)
set colorcolumn=80

" Indentation Rules
set tabstop=4      " tab size
set softtabstop=4  " make space feel like a tab, will bs as if a tab
set shiftwidth=4   " indentation used for >>
set noexpandtab    " do not use spaces to fill tabs
set cindent        " automatic indentation for c programs

" perform dot commands over visual blocks
vnoremap . :normal .<CR>
" display tabs and trailing whitespace
set list listchars=tab:›\ ,trail:·,nbsp:·
" Disable auto commenting on new line
autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o
" Remove highlighted search results with enter
nnoremap <silent><Esc><Esc> :nohlsearch<CR>
" Spell-check set to <leader>o
map <leader>o :setlocal spell! spelllang=en_us<CR>

" Relative line numbering (toggles off in insert mode)
set number relativenumber
augroup numbertoggle
	autocmd!
	autocmd BufEnter,FocusGained,InsertLeave * set relativenumber
	autocmd BufLeave,FocusLost,InsertEnter   * set norelativenumber
augroup END

" toggle fold with <CR> (same as za)
nnoremap <silent> <CR> @=(foldlevel('.')?'za':"\<Space>")<CR>
" fold method
set foldmethod=marker

" Use wl-clipboard
xnoremap "+y y:call system("wl-copy", @")<cr>
nnoremap "+p :let @"=substitute(system("wl-paste --no-newline"), '<C-v><C-m>', '', 'g')<cr>p
nnoremap "*p :let @"=substitute(system("wl-paste --no-newline --primary"), '<C-v><C-m>', '', 'g')<cr>p

" Easier access to clipboard mappings
vnoremap <leader>y "+y
vnoremap <leader>p "+p

" Ultisnips
let g:UltiSnipsExpandTrigger='<c-f>'
let g:UltiSnipsJumpForwardTrigger="<c-e>"
let g:UltiSnipsJumpBackwardTrigger="<c-y>"

" If you want :UltiSnipsEdit to split your window.
let g:UltiSnipsEditSplit="vertical"

" ALE shortcuts
nmap <silent> <C-p> <Plug>(ale_previous_wrap)
nmap <silent> <C-n> <Plug>(ale_next_wrap)
imap <C-Space> <Plug>(ale_complete)
nmap <silent> <C-i> <Plug>(ale_hover)
nmap <silent> <gd> <Plug>(ale_go_to_definition)
nmap <silent> <C-w>gd <Plug>(ale_go_to_definition_in_split)

" Completion {{{2
" command-mode completion settings
set wildmode=longest:full,full
" ignore case in cmd-mode
set wildignorecase
"enable omnicomplete
set omnifunc=syntaxcomplete#Complete
" suppress annoying messages.
set shortmess+=c
" settings for completion priority for C-n and C-p
set complete=.,w,b,u,i

" enable ale completion
let g:ale_completion_enabled = 1

" Tab completion
" will insert tab at beginning of line,
" will use completion if not at beginning
function! InsertTabWrapper()
    let col = col('.') - 1
    if !col || getline('.')[col - 1] !~ '\k'
        return "\<Tab>"
    else
        return "\<C-n>"
    endif
endfunction
inoremap <silent><Tab> <C-r>=InsertTabWrapper()<CR>
inoremap <S-Tab> <C-n>
" 2}}}

" 1}}}

" Navigation {{{1
" Split navigation {{{2
noremap <leader>h <C-w>h
noremap <leader>j <C-w>j
noremap <leader>k <C-w>k
noremap <leader>l <C-w>l

" increase size of current split by 1.5
nnoremap <silent> <Leader>+ :exe "resize " . (winheight(0) * 3/2)<CR>
" decrease size of current split by 0.66
nnoremap <silent> <Leader>- :exe "resize " . (winheight(0) * 2/3)<CR>

" Start :terminal in insert mode
autocmd TermOpen * startinsert
" Open terminal buffer split (current dir)
nnoremap <leader>; :below 15sp+te %:p:h<CR>
" esc+esc to exit terminal mode
tnoremap <ESC><ESC> <c-\><c-n>
" 2}}}

" File Manager (netrw) {{{2
let g:netrw_keepdir = 0  " Keep current directory and browsing directory synced
let g:netrw_winsize = 18  " Size of netrw buffer
let g:netrw_banner = 0  " Hide banner, toggle with I
let g:netrw_liststyle = 3  " Tree View
let g:netrw_list_hide = '\(^\|\s\s\)\zs\.\S\+'  " Hide dotfiles by default
let g:netrw_localcopydircmd = 'cp -r'  " Change cp to cp -r
let g:netrw_browse_split = 4  " Open file in previous active window
let g:netrw_preview = 1  " Preview splits
" Open netrw in current file path
nnoremap <leader>dd :Lexplore! %:p:h<CR>
" Open netrw in current working dir
nnoremap <Leader>da :Lexplore!<CR>

" Mappings to use in netrw
function! NetrwMapping()
	" go back in history
	nmap <buffer> H u
	" up a dir
	nmap <buffer> h -^
	" into a dir
	nmap <buffer> l <CR>

	" hidden files toggle
	nmap <buffer> . gh
	" close preview window
	nmap <buffer> P <C-w>z

	" open file and close netrw
	nmap <buffer> L <CR>:Lexplore!<CR>
	" toggle netrw
	nmap <buffer> <Leader>dd :Lexplore!<CR>

	" mark file
	nmap <buffer> <TAB> mf
	" unmark all files in current buffer
	nmap <buffer> <S-TAB> mF
	" unmark all files
	nmap <buffer> <Leader><TAB> mu

	" create a file
	nmap <buffer> ff %:w<CR>:buffer #<CR>
	" rename a file
	nmap <buffer> fe R
	" copy marked files
	nmap <buffer> fP mc
	" copy marked files to current dir
	nmap <buffer> fp mtmc
	" move marked files
	nmap <buffer> fV mm
	" move marked files to current dir
	nmap <buffer> fv mtmm
	" external command on marked files
	nmap <buffer> f; mx
	" display list of marked files
	nmap <buffer> fl :echo join(netrw#Expose("netrwmarkfilelist"), "\n")<CR>
	" show target dir
	nmap <buffer> fq :echo 'Target:' . netrw#Expose("netrwmftgt")<CR>
	nmap <buffer> fd mtfq
endfunction

augroup netrw_mapping
	autocmd!
	autocmd filetype netrw call NetrwMapping()
augroup END

" close if final buffer is netrw or the quickfix
augroup finalcountdown
	au!
	autocmd WinEnter * if winnr('$') == 1 && getbufvar(winbufnr(winnr()), "&filetype") == "netrw" || &buftype == 'quickfix' |q|endif
	nmap - :Lexplore<cr>
augroup END
" 2}}}

" Project navigation {{{2
" easy buffer switching
nnoremap gb :buffers<CR>:buffer<Space>
" set path to all dirs and sub-dirs in current worrking dir
set path+=**
" add a file of an ext to buffer list and list files in current dir
nnoremap <leader>a :argadd <C-r>=fnameescape(expand('%:p:h'))<CR>/*<C-d>
" edit file relative to current file
nnoremap <leader>e :e <C-r>=fnameescape(expand('%:p:h'))<CR>/*<C-d>
" file shortcuts
nnoremap <leader>fp :argadd ~/programming/**
nnoremap <leader>fn :argadd ~/notes/**
nnoremap <leader>fh :argadd ~/**

" Jump to keyword number
nnoremap <F4> [I:let nr = input("Which one: ")<Bar>exe "normal " . nr ."[\t"<CR>

" change *** to **/* automatically
cnoremap <expr> * getcmdline() =~ '.*\*\*$' ? '/*' : '*'
" '%% <Space>' will change to current file+path
cnoreabbrev <expr> %% fnameescape(expand('%:p'))

" Detect .h files as c not cpp
augroup project
	autocmd!
	autocmd BufRead,BufNewFile *.h,*.c set filetype=c.doxygen
augroup END
" 2}}}

" Compile and run in a terminal buffer (single file)
autocmd BufWinEnter *.c nmap <F5> :w \| 15sp \| te gcc % -o %< -lm && ./%< <CR>
autocmd BufWinEnter *.cpp nmap <F5> :w \| 15sp \| te g++ % -o %< && ./%< <CR>
autocmd BufWinEnter *.py nmap <F5> :w \| 15sp \| te python3 %<CR>
autocmd BufWinEnter *.lua nmap <F5> :w \| 15sp \| te lua %<CR>
autocmd BufWinEnter *.sh nmap <F5> :w \| 15sp \| te /bin/sh %<CR>
" 1}}}

" Statusline {{{1
set statusline=

function! Statusline_expr()
	let mod  = "%{&modified ? '[+] ' : !&modifiable ? '[x] ' : ''}"
	let fug  = "%2*%{exists('g:loaded_fugitive') ? fugitive#statusline() : ''}"
	let sep  = '%='
	let fmt  = " %{&fileformat} |"
	let enc  = " %{&fileencoding?&fileencoding:&encoding} |"
	let ft   = " %{len(&filetype) ? &filetype : 'no ft'} |"
	let pec  = ' %p%% |'
	let pos  = ' %l:%c '

	return ' %<%t %r%<'.mod.fug.sep.fmt.enc.ft.pec.pos
endfunction
let &statusline = Statusline_expr()
set laststatus=2 " show statusbar
" 1}}
