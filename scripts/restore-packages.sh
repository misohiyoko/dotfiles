#!/bin/bash

# パッケージリストから復元するスクリプト
# Usage: ./restore-packages.sh

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PACKAGES_DIR="$SCRIPT_DIR/../packages"

# 色定義
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo "========================================="
echo "  パッケージ復元スクリプト"
echo "========================================="
echo ""

# パッケージリストの存在確認
if [ ! -f "$PACKAGES_DIR/pkglist.txt" ]; then
    echo "エラー: パッケージリストが見つかりません"
    echo "  パス: $PACKAGES_DIR/pkglist.txt"
    exit 1
fi

# 統計表示
official_count=$(wc -l < "$PACKAGES_DIR/pkglist.txt")
aur_count=0
if [ -f "$PACKAGES_DIR/aurlist.txt" ]; then
    aur_count=$(wc -l < "$PACKAGES_DIR/aurlist.txt")
fi

echo "インストール予定:"
echo "  公式パッケージ: $official_count 個"
echo "  AURパッケージ: $aur_count 個"
echo ""

read -p "続行しますか? [y/N] " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "キャンセルしました"
    exit 0
fi

echo ""
echo -e "${GREEN}→${NC} 公式リポジトリからパッケージをインストール中..."
sudo pacman -S --needed - < "$PACKAGES_DIR/pkglist.txt"

if [ -f "$PACKAGES_DIR/aurlist.txt" ] && [ $aur_count -gt 0 ]; then
    echo ""
    echo -e "${GREEN}→${NC} AURからパッケージをインストール中..."

    # yayが存在するか確認
    if ! command -v yay &> /dev/null; then
        echo -e "${YELLOW}!${NC} yayがインストールされていません"
        echo "yayをインストールしてから再度実行してください"
        echo ""
        echo "yayのインストール方法:"
        echo "  git clone https://aur.archlinux.org/yay.git"
        echo "  cd yay"
        echo "  makepkg -si"
        exit 1
    fi

    yay -S --needed - < "$PACKAGES_DIR/aurlist.txt"
fi

echo ""
echo "========================================="
echo "  パッケージ復元完了"
echo "========================================="
