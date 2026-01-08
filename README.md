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
├── scripts/          # 管理スクリプト
│   ├── backup.sh              # 設定ファイルをdotfilesにコピー
│   ├── install.sh             # シンボリックリンクを展開
│   ├── save-packages.sh       # パッケージリストを保存
│   └── restore-packages.sh    # パッケージリストから復元
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

## 注意事項

- `install.sh` 実行時、既存のファイルは自動的にバックアップされます
- バックアップは `~/.dotfiles_backup_YYYYMMDD_HHMMSS/` に保存されます
- `--force` オプションで確認なしで上書きできます（非推奨）

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
