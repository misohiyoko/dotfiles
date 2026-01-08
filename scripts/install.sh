#!/bin/bash

# dotfilesからホームディレクトリにシンボリックリンクを展開するスクリプト
# Usage: ./install.sh [--force]

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_DIR="$(dirname "$SCRIPT_DIR")"
HOME_DIR="$HOME"
BACKUP_DIR="$HOME_DIR/.dotfiles_backup_$(date +%Y%m%d_%H%M%S)"

FORCE=false
if [[ "$1" == "--force" ]]; then
    FORCE=true
fi

# 色定義
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo "========================================="
echo "  Dotfiles インストールスクリプト"
echo "========================================="
echo ""
echo "ソース: $DOTFILES_DIR"
echo "展開先: $HOME_DIR"
echo ""

# バックアップディレクトリ作成フラグ
backup_created=false

# シンボリックリンクを作成する関数
create_symlink() {
    local source="$1"
    local target="$2"
    local rel_path="${target#$HOME_DIR/}"

    # ターゲットのディレクトリを作成
    local target_dir="$(dirname "$target")"
    mkdir -p "$target_dir"

    # 既存ファイル/リンクの処理
    if [ -e "$target" ] || [ -L "$target" ]; then
        if [ -L "$target" ]; then
            local current_link="$(readlink "$target")"
            if [ "$current_link" == "$source" ]; then
                echo -e "${GREEN}✓${NC} すでにリンク済み: $rel_path"
                return 0
            fi
        fi

        # バックアップ
        if [ "$FORCE" == false ]; then
            echo -e "${YELLOW}!${NC} 既存ファイル検出: $rel_path"
            read -p "  バックアップして上書きしますか? [y/N] " -n 1 -r
            echo
            if [[ ! $REPLY =~ ^[Yy]$ ]]; then
                echo -e "${RED}⊘${NC} スキップ: $rel_path"
                return 1
            fi
        fi

        # バックアップディレクトリ作成
        if [ "$backup_created" == false ]; then
            mkdir -p "$BACKUP_DIR"
            backup_created=true
            echo -e "${YELLOW}→${NC} バックアップ先: $BACKUP_DIR"
        fi

        # バックアップ実行
        local backup_path="$BACKUP_DIR/$rel_path"
        mkdir -p "$(dirname "$backup_path")"
        mv "$target" "$backup_path"
        echo -e "${YELLOW}→${NC} バックアップ: $rel_path"
    fi

    # シンボリックリンク作成
    ln -s "$source" "$target"
    echo -e "${GREEN}✓${NC} リンク作成: $rel_path -> $source"
}

# .config内のディレクトリをリンク
if [ -d "$DOTFILES_DIR/.config" ]; then
    echo "--- .config 配下の設定をリンク中 ---"
    for item in "$DOTFILES_DIR/.config"/*; do
        if [ -e "$item" ]; then
            basename_item="$(basename "$item")"
            create_symlink "$item" "$HOME_DIR/.config/$basename_item"
        fi
    done
    echo ""
fi

# ホーム直下のdotfilesをリンク
echo "--- ホーム直下のdotfilesをリンク中 ---"
for item in "$DOTFILES_DIR"/.*; do
    basename_item="$(basename "$item")"

    # 特殊ディレクトリをスキップ
    if [[ "$basename_item" == "." || "$basename_item" == ".." || "$basename_item" == ".git" || "$basename_item" == ".config" ]]; then
        continue
    fi

    # 通常のdotfileのみリンク
    if [ -f "$item" ] || [ -d "$item" ]; then
        create_symlink "$item" "$HOME_DIR/$basename_item"
    fi
done

echo ""
echo "========================================="
echo "  インストール完了"
echo "========================================="

if [ "$backup_created" == true ]; then
    echo ""
    echo "バックアップ: $BACKUP_DIR"
fi

echo ""
echo "次のステップ:"
echo "  - シェルを再起動して設定を反映"
echo "  - パッケージをインストール: ./restore-packages.sh"
