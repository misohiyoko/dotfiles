#!/bin/bash

# パッケージリストを保存するスクリプト
# Usage: ./save-packages.sh

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PACKAGES_DIR="$SCRIPT_DIR/../packages"

# ディレクトリが存在しない場合は作成
mkdir -p "$PACKAGES_DIR"

echo "パッケージリストを保存中..."

# 明示的にインストールされた公式リポジトリのパッケージ
pacman -Qqen > "$PACKAGES_DIR/pkglist.txt"
echo "✓ 公式リポジトリパッケージ: $PACKAGES_DIR/pkglist.txt"

# 明示的にインストールされたAURパッケージ
pacman -Qqem > "$PACKAGES_DIR/aurlist.txt"
echo "✓ AURパッケージ: $PACKAGES_DIR/aurlist.txt"

# 全パッケージの詳細情報（バックアップ用）
pacman -Qe > "$PACKAGES_DIR/pkglist-detailed.txt"
echo "✓ 詳細情報: $PACKAGES_DIR/pkglist-detailed.txt"

echo ""
echo "統計情報:"
echo "  公式パッケージ: $(wc -l < "$PACKAGES_DIR/pkglist.txt") 個"
echo "  AURパッケージ: $(wc -l < "$PACKAGES_DIR/aurlist.txt") 個"
echo "  合計: $(pacman -Qq | wc -l) 個（依存関係含む）"
