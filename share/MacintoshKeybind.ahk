#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

; これ以外のkeybindの変更はこちらを参考にする https://qiita.com/kokorinosoba/items/fb4d5070297dba8dc18c
; このファイルをWindowsのスタートアップフォルダに入れる

; カーソル移動のキーバインド
F13 & P::Send,{Up}
F13 & N::Send,{Down}
F13 & B::Send,{Left}
F13 & F::Send,{Right}
F13 & A::Send,{Home}
F13 & E::Send,{End}

; テキスト編集のキーバインド
F13 & O::Send,{End}{Enter} ; 改行
F13 & H::Send,{Backspace} ; Backspace
F13 & D::Send,{Delete} ; Delete
F13 & K::Send,{ShiftDown}{End}{ShiftUp}^x ; キル（一行切り取り）
F13 & Y::Send,^v ; ヤンク（ペースト）
F13 & T::Send,{ShiftDown}{Left}{ShiftUp}^x{Right}^v{Left} ; カーソル前後の文字を入れ替え

; ターミナルなどで使えるキーバインド
F13 & L::Send,^l ; ターミナルの画面をclearする
F13 & C::Send,^c ; 中断: Ctrl-C
F13 & R::Send,^r
F13 & [::Send,{Esc} ; vimでコマンドモードに戻る用
F13 & J::Send,{End}{Enter}
F13 & Enter::Send,{F14}

; アプリケーションを終了させる（Cmd-Q)
Ctrl & Q::Send,!{F4}

; WinをMacのspotlight風に
Ctrl & Space::Send,{CtrlUp}{RWinDown}{RWinUp}

; ファイル削除: Delete
RWin & BS::Send,{Delete}

; 右シフト横のろキーを押したときに¥マークではなく，_が入力されるようにする
vkE2::Send,_

; Sleepのショートカット
F19::DllCall("PowrProf\SetSuspendState", "int", 0, "int", 0, "int", 0) Return
