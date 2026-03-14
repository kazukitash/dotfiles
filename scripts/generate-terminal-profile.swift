#!/usr/bin/env swift

import Cocoa

// Catppuccin Latte カラーパレット
let colors: [(String, CGFloat, CGFloat, CGFloat, CGFloat)] = [
  ("BackgroundColor",       0xEF/255.0, 0xF1/255.0, 0xF5/255.0, 1.0),
  ("TextColor",             0x4C/255.0, 0x4F/255.0, 0x69/255.0, 1.0),
  ("TextBoldColor",         0x6C/255.0, 0x6F/255.0, 0x85/255.0, 1.0),
  ("CursorColor",           0xDC/255.0, 0x8A/255.0, 0x78/255.0, 1.0),
  ("SelectionColor",        0xAC/255.0, 0xB0/255.0, 0xBE/255.0, 0.5),
  ("ANSIBlackColor",        0xBC/255.0, 0xC0/255.0, 0xCC/255.0, 1.0),
  ("ANSIRedColor",          0xD2/255.0, 0x0F/255.0, 0x39/255.0, 1.0),
  ("ANSIGreenColor",        0x40/255.0, 0xA0/255.0, 0x2B/255.0, 1.0),
  ("ANSIYellowColor",       0xDF/255.0, 0x8E/255.0, 0x1D/255.0, 1.0),
  ("ANSIBlueColor",         0x1E/255.0, 0x66/255.0, 0xF5/255.0, 1.0),
  ("ANSIMagentaColor",      0xEA/255.0, 0x76/255.0, 0xCB/255.0, 1.0),
  ("ANSICyanColor",         0x17/255.0, 0x92/255.0, 0x99/255.0, 1.0),
  ("ANSIWhiteColor",        0x5C/255.0, 0x5F/255.0, 0x77/255.0, 1.0),
  ("ANSIBrightBlackColor",  0x9C/255.0, 0xA0/255.0, 0xB0/255.0, 1.0),
  ("ANSIBrightRedColor",    0xD2/255.0, 0x0F/255.0, 0x39/255.0, 1.0),
  ("ANSIBrightGreenColor",  0x40/255.0, 0xA0/255.0, 0x2B/255.0, 1.0),
  ("ANSIBrightYellowColor", 0xDF/255.0, 0x8E/255.0, 0x1D/255.0, 1.0),
  ("ANSIBrightBlueColor",   0x1E/255.0, 0x66/255.0, 0xF5/255.0, 1.0),
  ("ANSIBrightMagentaColor",0xEA/255.0, 0x76/255.0, 0xCB/255.0, 1.0),
  ("ANSIBrightCyanColor",   0x17/255.0, 0x92/255.0, 0x99/255.0, 1.0),
  ("ANSIBrightWhiteColor",  0x6C/255.0, 0x6F/255.0, 0x85/255.0, 1.0),
]

// NSColor を NSKeyedArchiver でエンコード
func archiveColor(_ r: CGFloat, _ g: CGFloat, _ b: CGFloat, _ a: CGFloat) -> Data {
  let color = NSColor(calibratedRed: r, green: g, blue: b, alpha: a)
  return try! NSKeyedArchiver.archivedData(withRootObject: color, requiringSecureCoding: false)
}

// 既存プロファイルを読み込み
let scriptDir = URL(fileURLWithPath: #file).deletingLastPathComponent()
let dotfilesDir = scriptDir.deletingLastPathComponent()
let sourceURL = dotfilesDir.appendingPathComponent("share/Yawaraka.terminal")
let destURL = dotfilesDir.appendingPathComponent("share/Yawaraka-Light.terminal")

guard let dict = NSMutableDictionary(contentsOf: sourceURL) else {
  fputs("エラー: \(sourceURL.path) を読み込めません\n", stderr)
  exit(1)
}

// カラーデータを置換
for (key, r, g, b, a) in colors {
  dict[key] = archiveColor(r, g, b, a)
}

// 名前とブラーを変更
dict["name"] = "Yawaraka-Light"
dict["BackgroundBlur"] = 0.0

// XML plist として書き出し
guard dict.write(to: destURL, atomically: true) else {
  fputs("エラー: \(destURL.path) への書き込みに失敗\n", stderr)
  exit(1)
}

print("生成完了: \(destURL.path)")
