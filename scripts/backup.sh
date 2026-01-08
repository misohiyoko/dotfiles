#!/bin/bash

# 設定ファイルをdotfilesディレクトリにコピーするスクリプト
# Usage: ./backup.sh

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_DIR="$(dirname "$SCRIPT_DIR")"
HOME_DIR="$HOME"

# 管理する設定ファイル・ディレクトリのリスト
# 形式: "ソースパス:保存先パス" (ホームディレクトリからの相対パス)
CONFIG_FILES=(
    # .config配下
    ".config/hypr"
    ".config/kitty"
    ".config/fcitx5"
    ".config/gtk-3.0"
    ".config/gtk-4.0"
    ".config/htop"
    ".config/electron-flags.conf"
    ".config/wofi"
    ".config/waybar"
    ".config/yay"

    # ホーム直下のdotfiles
    ".bashrc"
    ".zshrc"
    ".gitconfig"
    "dolphinrc"
    ".xinitrc"
    ".xprofile"
)

echo "設定ファイルをdotfilesにバックアップ中..."
echo ""

# カウンター
copied=0
skipped=0

for item in "${CONFIG_FILES[@]}"; do
    source_path="$HOME_DIR/$item"
    dest_path="$DOTFILES_DIR/$item"

    # ソースが存在するか確認
    if [ -e "$source_path" ]; then
        # 保存先ディレクトリを作成
        dest_dir="$(dirname "$dest_path")"
        mkdir -p "$dest_dir"

        # コピー実行
        if [ -d "$source_path" ]; then
            # ディレクトリの場合
            cp -r "$source_path" "$dest_dir/"
            echo "✓ ディレクトリをコピー: $item"
        else
            # ファイルの場合
            cp "$source_path" "$dest_path"
            echo "✓ ファイルをコピー: $item"
        fi
        ((copied++))
    else
        echo "⊘ スキップ (存在しない): $item"
        ((skipped++))
    fi
done

echo ""
echo "完了: $copied 個コピー, $skipped 個スキップ"
echo ""
echo "次のステップ:"
echo "  1. パッケージリストを保存: ./save-packages.sh"
echo "  2. Gitリポジトリを初期化: cd $DOTFILES_DIR && git init"
echo "  3. 変更をコミット: git add . && git commit -m 'Initial commit'"
