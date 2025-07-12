-- 横に番号表示
vim.opt.number = true

-- 括弧の対応を確認する
vim.opt.showmatch = true

-- スクロール時に上と下に３行確保
vim.opt.scrolloff = 3

-- 上のインデントをそのままで改行
vim.opt.autoindent = true

-- タブキーを押すとスペースになる
vim.opt.expandtab = true

-- タブをスペース２つ分に
vim.opt.tabstop = 2

-- 自動インデントに使われる空白の数
vim.opt.shiftwidth = 2

-- 履歴を１万件保存
vim.opt.history = 10000

-- ビープ音削除
vim.opt.visualbell = true

-- 今いる行などを右下に表示
vim.opt.ruler = true

-- 編集中のファイル名を上に表示
vim.opt.title = true

-- テーマカラー（主に文字色）
vim.opt.background = "dark"
vim.cmd("colorscheme slate")

-- 文字をカラーに
vim.cmd("syntax on")

-- 行頭行末の左右移動で行をまたぐ
vim.opt.whichwrap = "b,s,h,l,<,>,[,]"

-- 検索時に大文字と小文字を区別しない
vim.opt.ignorecase = true

-- 検索時に大文字と小文字が混ざった言葉で検索したら区別する
vim.opt.smartcase = true

-- コメントに色をつける
vim.cmd("hi Comment ctermfg=25")

-- マウススクロールなどを可能にする
vim.opt.mouse = "a"

-- 前回編集した箇所から編集
vim.api.nvim_create_augroup("RestoreCursor", { clear = true })
vim.api.nvim_create_autocmd("BufReadPost", {
  group = "RestoreCursor",
  pattern = "*",
  callback = function()
    local line = vim.fn.line("'\"")
    if line > 1 and line <= vim.fn.line("$") then
      vim.cmd("normal! g`\"")
    end
  end,
})

-- 10000行までヤンク可能にする
vim.opt.shada = "'20,\"10000"

-- ハイライトON
vim.opt.hlsearch = true

-- キーマッピング
vim.keymap.set("n", "k", "gk", { noremap = true })
vim.keymap.set("n", "j", "gj", { noremap = true })
vim.keymap.set("v", "k", "gk", { noremap = true })
vim.keymap.set("v", "j", "gj", { noremap = true })
vim.keymap.set("n", "gk", "k", { noremap = true })
vim.keymap.set("n", "gj", "j", { noremap = true })
vim.keymap.set("v", "gk", "k", { noremap = true })
vim.keymap.set("v", "gj", "j", { noremap = true })
