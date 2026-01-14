#!/bin/bash

# Dotfiles 初期化スクリプト
# 新しいPCでの初期セットアップを自動化します
# Usage: ./initialize.sh [--skip-packages] [--skip-wallpaper] [--skip-voicepeak]

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_DIR="$(dirname "$SCRIPT_DIR")"

# 色定義
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# オプション解析
SKIP_PACKAGES=false
SKIP_WALLPAPER=false
SKIP_VOICEPEAK=false

while [[ $# -gt 0 ]]; do
    case $1 in
        --skip-packages)
            SKIP_PACKAGES=true
            shift
            ;;
        --skip-wallpaper)
            SKIP_WALLPAPER=true
            shift
            ;;
        --skip-voicepeak)
            SKIP_VOICEPEAK=true
            shift
            ;;
        *)
            echo "Unknown option: $1"
            echo "Usage: $0 [--skip-packages] [--skip-wallpaper] [--skip-voicepeak]"
            exit 1
            ;;
    esac
done

# ヘッダー
clear
echo -e "${CYAN}=================================================${NC}"
echo -e "${CYAN}   Dotfiles 初期化スクリプト${NC}"
echo -e "${CYAN}=================================================${NC}"
echo ""
echo "このスクリプトは以下の処理を実行します："
echo ""
echo "  1. ${BLUE}Dotfilesのシンボリックリンク作成${NC} (install.sh)"
echo "  2. ${BLUE}パッケージの復元${NC} (restore-packages.sh)"
echo "  3. ${BLUE}壁紙の設定${NC} (set-wallpaper.sh)"
echo "  4. ${BLUE}VOICEPEAKのインストール${NC} (install-voicepeak.sh)"
echo ""
echo "スキップされる処理："
[ "$SKIP_PACKAGES" = true ] && echo "  - パッケージの復元"
[ "$SKIP_WALLPAPER" = true ] && echo "  - 壁紙の設定"
[ "$SKIP_VOICEPEAK" = true ] && echo "  - VOICEPEAKのインストール"
echo ""
read -p "続行しますか? [Y/n] " -n 1 -r
echo
if [[ $REPLY =~ ^[Nn]$ ]]; then
    echo "初期化をキャンセルしました。"
    exit 0
fi

# エラーハンドリング関数
handle_error() {
    local step=$1
    local continue_prompt=$2

    echo ""
    echo -e "${RED}✗${NC} ${step}でエラーが発生しました。"

    if [ "$continue_prompt" = true ]; then
        read -p "続行しますか? [y/N] " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            echo "初期化を中断しました。"
            exit 1
        fi
    else
        echo "初期化を中断しました。"
        exit 1
    fi
}

# ステップカウンター
STEP=0
total_steps=4
[ "$SKIP_PACKAGES" = true ] && ((total_steps--))
[ "$SKIP_WALLPAPER" = true ] && ((total_steps--))
[ "$SKIP_VOICEPEAK" = true ] && ((total_steps--))

# ============================================
# ステップ 1: Dotfilesのシンボリックリンク作成
# ============================================
((STEP++))
echo ""
echo -e "${CYAN}=================================================${NC}"
echo -e "${CYAN}ステップ $STEP/$total_steps: Dotfilesのシンボリックリンク作成${NC}"
echo -e "${CYAN}=================================================${NC}"
echo ""

cd "$SCRIPT_DIR" || exit 1

if [ -f "install.sh" ]; then
    if ./install.sh --force; then
        echo -e "${GREEN}✓${NC} シンボリックリンクの作成が完了しました。"
    else
        handle_error "シンボリックリンクの作成" false
    fi
else
    echo -e "${YELLOW}!${NC} install.shが見つかりません。スキップします。"
fi

# ============================================
# ステップ 2: パッケージの復元
# ============================================
if [ "$SKIP_PACKAGES" = false ]; then
    ((STEP++))
    echo ""
    echo -e "${CYAN}=================================================${NC}"
    echo -e "${CYAN}ステップ $STEP/$total_steps: パッケージの復元${NC}"
    echo -e "${CYAN}=================================================${NC}"
    echo ""

    if [ -f "restore-packages.sh" ]; then
        echo "パッケージのインストールには時間がかかる場合があります..."
        echo ""

        if ./restore-packages.sh; then
            echo -e "${GREEN}✓${NC} パッケージの復元が完了しました。"
        else
            handle_error "パッケージの復元" true
        fi
    else
        echo -e "${YELLOW}!${NC} restore-packages.shが見つかりません。スキップします。"
    fi
fi

# ============================================
# ステップ 3: 壁紙の設定
# ============================================
if [ "$SKIP_WALLPAPER" = false ]; then
    ((STEP++))
    echo ""
    echo -e "${CYAN}=================================================${NC}"
    echo -e "${CYAN}ステップ $STEP/$total_steps: 壁紙の設定${NC}"
    echo -e "${CYAN}=================================================${NC}"
    echo ""

    if [ -f "set-wallpaper.sh" ]; then
        read -p "壁紙を設定しますか? [Y/n] " -n 1 -r
        echo

        if [[ ! $REPLY =~ ^[Nn]$ ]]; then
            if ./set-wallpaper.sh --random; then
                echo -e "${GREEN}✓${NC} 壁紙の設定が完了しました。"
            else
                handle_error "壁紙の設定" true
            fi
        else
            echo "壁紙の設定をスキップしました。"
        fi
    else
        echo -e "${YELLOW}!${NC} set-wallpaper.shが見つかりません。スキップします。"
    fi
fi

# ============================================
# ステップ 4: VOICEPEAKのインストール
# ============================================
if [ "$SKIP_VOICEPEAK" = false ]; then
    ((STEP++))
    echo ""
    echo -e "${CYAN}=================================================${NC}"
    echo -e "${CYAN}ステップ $STEP/$total_steps: VOICEPEAKのインストール${NC}"
    echo -e "${CYAN}=================================================${NC}"
    echo ""

    read -p "VOICEPEAKをインストールしますか? [y/N] " -n 1 -r
    echo

    if [[ $REPLY =~ ^[Yy]$ ]]; then
        if [ -f "install-voicepeak.sh" ]; then
            if ./install-voicepeak.sh; then
                echo -e "${GREEN}✓${NC} VOICEPEAKのインストールが完了しました。"
            else
                handle_error "VOICEPEAKのインストール" true
            fi
        else
            echo -e "${YELLOW}!${NC} install-voicepeak.shが見つかりません。スキップします。"
        fi
    else
        echo "VOICEPEAKのインストールをスキップしました。"
    fi
fi

# ============================================
# 完了
# ============================================
echo ""
echo -e "${GREEN}=================================================${NC}"
echo -e "${GREEN}   初期化完了！${NC}"
echo -e "${GREEN}=================================================${NC}"
echo ""
echo "次のステップ："
echo ""
echo "  1. ${BLUE}シェルを再起動${NC}して設定を反映："
echo "     ${CYAN}exec \$SHELL${NC}"
echo ""
echo "  2. ${BLUE}Hyprlandを再起動${NC}して設定を反映："
echo "     ${CYAN}Super+Shift+M${NC} (または再ログイン)"
echo ""
echo "  3. 必要に応じて${BLUE}追加の手動設定${NC}を実行："
echo "     - fcitx5の入力メソッド設定"
echo "     - アプリケーション固有の設定"
echo ""
echo -e "${YELLOW}注意:${NC} 一部の設定は再起動後に反映されます。"
echo ""
