# Dotfiles

個人的な設定ファイルとパッケージリストの管理リポジトリ

## 環境

- OS: Arch Linux
- ディスプレイサーバー: Wayland
- ウィンドウマネージャー: Hyprland
- ターミナル: Kitty
- 入力メソッド: fcitx5 + Mozc

## ディレクトリ構成

```
dotfiles/
├── .config/           # 各種アプリの設定ファイル
│   ├── hypr/         # Hyprland設定
│   ├── kitty/        # Kittyターミナル設定
│   ├── fcitx5/       # fcitx5入力メソッド設定
│   └── ...
├── wallpaper/        # 壁紙ファイル
├── scripts/          # 管理スクリプト
│   ├── backup.sh              # 設定ファイルをdotfilesにコピー
│   ├── install.sh             # シンボリックリンクを展開
│   ├── save-packages.sh       # パッケージリストを保存
│   ├── restore-packages.sh    # パッケージリストから復元
│   ├── set-wallpaper.sh       # 壁紙を設定
│   └── wallpaper-timer.sh     # 定期的に壁紙をランダム変更
└── packages/         # パッケージリスト
    ├── pkglist.txt            # 公式リポジトリパッケージ
    ├── aurlist.txt            # AURパッケージ
    └── pkglist-detailed.txt   # 詳細情報
```

## 使い方

### 初回セットアップ（このリポジトリをクローンした環境）

1. リポジトリをクローン
```bash
git clone https://github.com/YOUR_USERNAME/dotfiles.git ~/dotfiles
cd ~/dotfiles
```

2. パッケージをインストール
```bash
./scripts/restore-packages.sh
```

3. 設定ファイルをシンボリックリンクで展開
```bash
./scripts/install.sh
```

4. シェルを再起動
```bash
exec $SHELL
```

### 設定を更新する場合

1. 現在の設定ファイルをdotfilesにバックアップ
```bash
./scripts/backup.sh
```

2. パッケージリストを更新
```bash
./scripts/save-packages.sh
```

3. 変更をコミット
```bash
git add .
git commit -m "Update configs"
git push
```

### 壁紙を設定する

壁紙は `~/dotfiles/wallpaper/` ディレクトリで管理されます。

```bash
# 対話的に壁紙を選択
./scripts/set-wallpaper.sh

# 壁紙を指定して設定
./scripts/set-wallpaper.sh wallpaper.jpg

# ランダムに壁紙を設定
./scripts/set-wallpaper.sh --random

# 定期的に壁紙を変更（30分ごと）
./scripts/wallpaper-timer.sh 30
```

新しい壁紙を追加：
```bash
# 壁紙ファイルを追加
cp /path/to/your/wallpaper.jpg ~/dotfiles/wallpaper/

# Git管理に追加
cd ~/dotfiles
git add wallpaper/
git commit -m "Add new wallpaper"
```

## 注意事項

- `install.sh` 実行時、既存のファイルは自動的にバックアップされます
- バックアップは `~/.dotfiles_backup_YYYYMMDD_HHMMSS/` に保存されます
- `--force` オプションで確認なしで上書きできます
- シンボリックリンク使用時は、設定ファイルの直接編集が即座にdotfilesに反映されます

## トラブルシューティング

### Xwaylandアプリのキーボード配列問題

Hyprlandで一部のX11アプリ（SDL使用アプリなど）がUSキーボード配列になる場合：

```bash
# Hyprland設定に追加
exec-once = setxkbmap -layout jp
```

詳細: [issues/001-xwayland-keyboard.md](issues/001-xwayland-keyboard.md)

## ライセンス

MIT License
