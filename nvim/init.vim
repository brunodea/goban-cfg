"Do not forget to call :PlugInstall
call plug#begin()
"Plug 'leafgarland/typescript-vim'
Plug 'mhartington/oceanic-next'
Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }
Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'Yggdroot/indentLine'
Plug 'rust-lang/rust.vim'
Plug 'cespare/vim-toml', { 'branch': 'main' }
Plug 'jeffkreeftmeijer/vim-numbertoggle'
Plug 'https://github.com/jremmen/vim-ripgrep'

call plug#end()

let g:python_host_prog = '/usr/local/bin/python3'

" Theme
syntax enable
let g:oceanic_next_terminal_bold = 1
let g:oceanic_next_terminal_italic = 1
set background=dark


colorscheme OceanicNext

if (has("termguicolors"))
 set termguicolors
endif

" Respect tmux pane focus for dimming
if exists('$TMUX')
  augroup tmux_focus
    autocmd!
    " Dim background when pane loses focus (matches tmux colour237)
    autocmd FocusLost * hi Normal guibg=#3a3a3a
    autocmd FocusLost * hi EndOfBuffer guibg=#3a3a3a
    autocmd FocusLost * hi LineNr guibg=#3a3a3a
    autocmd FocusLost * hi CursorLineNr guibg=#3a3a3a
    " Restore normal background when pane gains focus
    autocmd FocusGained * hi Normal guibg=#1b2b34
    autocmd FocusGained * hi EndOfBuffer guibg=#1b2b34
    autocmd FocusGained * hi LineNr guibg=#1b2b34
    autocmd FocusGained * hi CursorLineNr guibg=#1b2b34
  augroup END
endif

" Open NERDTree on startup
"autocmd VimEnter * NERDTree
" Go to previous (last accessed) window.
"autocmd VimEnter * wincmd p

nmap <C-d> :NERDTreeToggle<CR>
nmap <C-s> :NERDTreeFind<CR>

function! s:GetNERDTreeRoot()
  " Look for a NERDTree window in the *current tab* first …
  for buf in tabpagebuflist(tabpagenr())
        \ + range(1, bufnr('$'))   " … then anywhere else.
    if getbufvar(buf, '&filetype') ==# 'nerdtree'
      " Either of these buffer-locals is present in modern NERDTree:
      "   b:NERDTree          (dict)           -> .root.path.str()
      "   b:NERDTreeRoot      (TreeDirNode)    -> .path.str()
      let rootdict = getbufvar(buf, 'NERDTree',   {})
      let rootnode = getbufvar(buf, 'NERDTreeRoot', {})
      if has_key(rootdict, 'root')
        return rootdict.root.path.str()
      elseif get(rootnode, 'path', 0) != 0
        return rootnode.path.str()
      endif
    endif
  endfor
  return ''   " nothing found
endfunction

" Configure fzf to include hidden files/folders
let $FZF_DEFAULT_COMMAND = 'find . -type f -not -path "*/\.git/*"'

function! FzfFromNerdTreeRoot()
  let l:path = s:GetNERDTreeRoot()
  if empty(l:path)
    " No NERDTree?  Use Vim's cwd so the mapping always does *something*.
    let l:path = getcwd()
  endif
  execute 'FZF' fnameescape(l:path)
endfunction

" Map it to a key, for example <Leader>fz
nnoremap <C-\> :call FzfFromNerdTreeRoot()<CR>

"nmap <C-q> :TagbarToggle<CR>
"
let g:rustfmt_autosave = 1
set hidden
let g:racer_cmd = "/home/bruno/.rust/cargo/bin/racer"
let g:racer_experimental_completer = 1
au FileType rust nmap gd <Plug>(rust-def)
au FileType rust nmap gs <Plug>(rust-def-split)
au FileType rust nmap gx <Plug>(rust-def-vertical)
au FileType rust nmap <leader>gd <Plug>(rust-doc)

"let g:airline_theme='oceanicnext'
"To enable airline (it only starts working after the window is split
"set laststatus=2
"needs devicons
"let g:airline_powerline_fonts = 1

set number relativenumber

"nmap <leader>z <Plug>Zeavim
"vmap <leader>z <Plug>ZVVisSelection
"nmap gz <Plug>ZVOperator
"nmap <leader><leader>z <Plug>ZVKeyDocset

"Toggle line number style
"let g:NumberToggleTrigger="<F2>"

set hlsearch
set cursorline
"removes trailing spaces by pressing F5
nnoremap <silent> <F5> :let _s=@/<Bar>:%s/\s\+$//e<Bar>:let @/=_s<Bar>:nohl<CR>

" Tab navigation like Firefox.
nnoremap <C-S-g> :tabprevious<CR>
nnoremap <C-g>   :tabNext<CR>
nnoremap <C-t>     :tabnew<CR>
inoremap <C-S-g> <Esc>:tabprevious<CR>i
inoremap <C-g>   <Esc>:tabNext<CR>i
inoremap <C-t> <Esc>:tabnew<CR>

" Kill the capslock when leaving insert mode.
"autocmd InsertLeave * set iminsert=0
" Quit VIM if only NERDTree is open
"autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

" Set incremental search
set is

"let g:UltiSnipsExpandTrigger="<C-Space>"
"let g:UltiSnipsJumpForwardTrigger="<c-b>"
"let g:UltiSnipsJumpBackwardTrigger="<c-z>"
"
let g:python_host_prog = '/usr/bin/python'
let g:python3_host_prog = '/usr/local/bin/python3'

" Auto enable auto formatting
"autocmd FileType c,cpp,h,hpp ClangFormatAutoEnable
"set hidden
"let g:racer_cmd = "/Users/brunor/.cargo/bin/racer"
"let g:racer_experimental_completer = 1

" For VIM Wiki
set nocompatible
filetype plugin on
syntax on

"let g:ycm_extra_conf_globlist = ['~/Documents/work/*', '~/Documents/prj/*']
"nnoremap <C-h> :YcmCompleter GoToDefinitionElseDeclaration<CR>

let g:NERDTreeIgnore=['gen_build']

let g:rg_command = 'rg --vimgrep --no-ignore-messages'
au BufEnter,BufRead *.tsx set filetype=typescript

"disable mouse
set mouse=

"As per :help 'expandtab
set tabstop=4 softtabstop=4 shiftwidth=4 expandtab

" Session management commands
function! SaveSessionWithNERDTree()
    " Save which tabs have NERDTree open and their root directories
    let nerdtree_data = []
    let current_tab = tabpagenr()
    
    for i in range(1, tabpagenr('$'))
        execute 'tabnext ' . i
        for buf in tabpagebuflist()
            if getbufvar(buf, '&filetype') ==# 'nerdtree'
                " Get the NERDTree root for this tab
                let root_path = s:GetNERDTreeRoot()
                if !empty(root_path)
                    call add(nerdtree_data, {'tab': i, 'root': root_path})
                else
                    call add(nerdtree_data, {'tab': i, 'root': getcwd()})
                endif
                break
            endif
        endfor
    endfor
    
    " Return to original tab
    execute 'tabnext ' . current_tab
    
    " Close all NERDTree instances
    if exists(":NERDTreeCloseAll")
        NERDTreeCloseAll
    endif
    
    " Save session
    mksession! ~/.config/nvim/session.vim
    
    " Save NERDTree state to a separate file with root paths
    let output_lines = []
    for item in nerdtree_data
        call add(output_lines, item.tab . '|' . item.root)
    endfor
    call writefile(output_lines, expand('~/.config/nvim/nerdtree_tabs.txt'))
    
    " Restore NERDTree in tabs that had it
    for item in nerdtree_data
        execute 'tabnext ' . item.tab
        execute 'NERDTree ' . fnameescape(item.root)
    endfor
    
    " Return to original tab
    execute 'tabnext ' . current_tab
endfunction

function! LoadSessionWithNERDTree()
    " Load session
    source ~/.config/nvim/session.vim
    
    " Load NERDTree state
    let nerdtree_file = expand('~/.config/nvim/nerdtree_tabs.txt')
    if filereadable(nerdtree_file)
        let nerdtree_lines = readfile(nerdtree_file)
        let current_tab = tabpagenr()
        
        " Parse and restore NERDTree in tabs that had it
        for line in nerdtree_lines
            let parts = split(line, '|', 1)
            if len(parts) >= 2
                let tab = str2nr(parts[0])
                let root_path = parts[1]
                if tab <= tabpagenr('$') && isdirectory(root_path)
                    execute 'tabnext ' . tab
                    execute 'NERDTree ' . fnameescape(root_path)
                endif
            endif
        endfor
        
        " Return to original tab
        execute 'tabnext ' . current_tab
    endif
endfunction

command! SaveSession call SaveSessionWithNERDTree()
command! LoadSession call LoadSessionWithNERDTree()

" Key mappings for session management
nnoremap <leader>ss :SaveSession<CR>
nnoremap <leader>sl :LoadSession<CR>
