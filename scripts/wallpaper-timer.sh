#!/bin/bash

# 定期的に壁紙をランダム変更するスクリプト
# Usage: ./wallpaper-timer.sh [interval-in-minutes]

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SET_WALLPAPER_SCRIPT="$SCRIPT_DIR/set-wallpaper.sh"

# デフォルトのインターバル（分）
DEFAULT_INTERVAL=30

# 色定義
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# インターバルを取得
INTERVAL="${1:-$DEFAULT_INTERVAL}"

# 数値チェック
if ! [[ "$INTERVAL" =~ ^[0-9]+$ ]]; then
    echo "エラー: インターバルは数値で指定してください"
    echo "Usage: $0 [interval-in-minutes]"
    exit 1
fi

echo -e "${BLUE}=========================================${NC}"
echo -e "${BLUE}  壁紙自動変更タイマー${NC}"
echo -e "${BLUE}=========================================${NC}"
echo ""
echo -e "インターバル: ${GREEN}${INTERVAL}分${NC}"
echo ""
echo "Ctrl+C で停止"
echo ""

# 初回実行
echo -e "${YELLOW}→${NC} 初回壁紙設定..."
"$SET_WALLPAPER_SCRIPT" --random

# タイマーループ
counter=1
while true; do
    sleep "${INTERVAL}m"
    echo ""
    echo -e "${BLUE}[$(date '+%Y-%m-%d %H:%M:%S')]${NC} 壁紙変更 (#$counter)"
    "$SET_WALLPAPER_SCRIPT" --random
    ((counter++))
done
