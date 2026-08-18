# Dotfiles

Arch Linux + Hyprland 用の個人設定です。

## セットアップ

```bash
git clone <repo-url> ~/dotfiles
cd ~/dotfiles
./scripts/install.sh
./scripts/restore-packages.sh
./scripts/set-wallpaper.sh --random
```

## 管理

```bash
./scripts/backup.sh             # ホームから設定を取り込む
./scripts/save-packages.sh      # pacman/AUR のパッケージ一覧を保存
./scripts/restore-packages.sh   # 保存したパッケージを復元
./scripts/set-wallpaper.sh      # 壁紙を選択
```

`install.sh` は既存ファイルを `~/.dotfiles_backup_<timestamp>/` に退避し、
リポジトリ内の `.config`、`.local/bin`、ホーム直下の dotfile へシンボリックリンクを作成します。

Tailscale 経由の SSH を構成する場合のみ、次を実行します。

```bash
./scripts/setup-tailscale-ssh.sh
```

## 主な構成

- Hyprland / Waybar / Kitty / Wofi
- fcitx5 + Mozc
- Starship
- pacman + yay のパッケージ一覧
- Waybar からの BD ドライブ有効・無効切り替え
