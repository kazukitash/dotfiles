"横に番号表示
set number

"括弧の対応を確認する
set showmatch

"スクロール時に上と下に３行確保
set scrolloff=3

"上のインデントをそのままで改行
set autoindent

"タブキーを押すとスペースになる
set expandtab

"タブをスペース２つ分に
set tabstop=2

"自動インデントに使われる空白の数
set shiftwidth=2

"履歴を１万件保存
set history=10000

"ビープ音削除
set visualbell t_vb=
set novisualbell

"今いる行などを右下に表示
set ruler

"編集中のファイル名を上に表示
set title

"テーマカラー（主に文字色）
set background=dark
colorscheme slate

"文字をカラーに
syntax on

"行頭行末の左右移動で行をまたぐ
set whichwrap=b,s,h,l,<,>,[,]

"検索時に大文字と小文字を区別しない
set ignorecase

"検索時に大文字と小文字が混ざった言葉で検索したら区別する
set smartcase

"コメントに色をつける
hi Comment ctermfg=25

"マウススクロールなどを可能にする
set mouse=a
set ttymouse=xterm2

"前回編集した箇所から編集
au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g`\""

"10000行までヤンク可能にする
set viminfo='20,\"10000

"ハイライトON
set hlsearch

nnoremap k   gk
nnoremap j   gj
vnoremap k   gk
vnoremap j   gj
nnoremap gk  k
nnoremap gj  j
vnoremap gk  k
vnoremap gj  j
