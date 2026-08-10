syntax on
filetype plugin indent on

set guioptions -=T
set hlsearch
set ignorecase

hi DiffAdd      gui=none    guifg=NONE          guibg=#bada9f
hi DiffChange   gui=none    guifg=NONE          guibg=#e5d5ac
hi DiffDelete   gui=bold    guifg=#ff8080       guibg=#ffb0b0
hi DiffText     gui=none    guifg=NONE          guibg=#8cbee2

map ;; :NERDTree ./<CR>
map ;s :NERDTree ~/Dev/bidder/src<CR>
map ;x :NERDTree ~/Dev/bidder/xml/Conventions<CR>
map ;g :NERDTree ~/Dev/grstats<CR>

map ,, :e#<cr>

map ,B :e $HOME/.bashrc<CR>
map ,S :source $HOME/.vimrc<CR>
map ,V :e $HOME/.vimrc<CR>
map ,n :noh

map <F3> dp<CR>
map <F4> do<CR>
map <S-F3> :1,$diffput<CR>:xa<CR>
map <S-F4> :1,$diffget<CR>:xa<CR>
