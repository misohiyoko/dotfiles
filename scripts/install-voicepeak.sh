#!/bin/bash

# VOICEPEAKインストールスクリプト
# Usage: ./install-voicepeak.sh

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_DIR="$(dirname "$SCRIPT_DIR")"
AUR_PACKAGE_DIR="$DOTFILES_DIR/aur-packages/voicepeak"
DOWNLOAD_URL="https://www.ah-soft.com/voice/setup/voicepeak-downloader-linux64"

# 色定義
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}=========================================${NC}"
echo -e "${BLUE}  VOICEPEAK インストールスクリプト${NC}"
echo -e "${BLUE}=========================================${NC}"
echo ""

# VOICEPEAKがすでにインストールされているか確認
if pacman -Qi voicepeak &>/dev/null; then
    echo -e "${GREEN}✓${NC} VOICEPEAKはすでにインストールされています。"
    read -p "再インストールしますか? [y/N] " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "インストールをスキップしました。"
        exit 0
    fi
    echo "既存のパッケージをアンインストールしています..."
    sudo pacman -R voicepeak --noconfirm
fi

# ~/Voicepeakが存在するか確認
if [ -d "$HOME/Voicepeak" ]; then
    echo -e "${GREEN}✓${NC} ~/Voicepeakが見つかりました。"
    VOICEPEAK_EXISTS=true
else
    echo -e "${YELLOW}!${NC} ~/Voicepeakが見つかりません。"
    VOICEPEAK_EXISTS=false
fi

# VOICEPEAKのダウンロード
if [ "$VOICEPEAK_EXISTS" = false ]; then
    echo ""
    echo -e "${BLUE}ステップ 1:${NC} VOICEPEAKのダウンロード"
    echo "----------------------------------------"

    # アーカイブを探す
    ARCHIVE=$(find "$HOME" -name "Voicepeak-linux64.zip" 2>/dev/null | head -1)

    if [ -n "$ARCHIVE" ]; then
        echo -e "${GREEN}✓${NC} アーカイブが見つかりました: $ARCHIVE"
        read -p "このアーカイブを使用しますか? [Y/n] " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Nn]$ ]]; then
            echo "アーカイブを展開しています..."
            unzip -q "$ARCHIVE" -d "$HOME"
            VOICEPEAK_EXISTS=true
        fi
    fi

    if [ "$VOICEPEAK_EXISTS" = false ]; then
        echo ""
        echo "VOICEPEAKをダウンロードする必要があります。"
        echo ""
        echo "オプション 1: ダウンローダーを使用（自動）"
        echo "オプション 2: 手動でダウンロード"
        echo ""
        read -p "ダウンローダーを使用しますか? [Y/n] " -n 1 -r
        echo

        if [[ ! $REPLY =~ ^[Nn]$ ]]; then
            # ダウンローダーを使用
            echo "ダウンローダーをダウンロードしています..."
            TEMP_DIR=$(mktemp -d)
            cd "$TEMP_DIR" || exit 1

            curl -L "$DOWNLOAD_URL" -o voicepeak-downloader-linux64
            chmod +x voicepeak-downloader-linux64

            echo ""
            echo "ダウンローダーを実行します..."
            echo ""
            ./voicepeak-downloader-linux64

            # ダウンロードされたアーカイブを探す
            echo ""
            echo "ダウンロードされたアーカイブを検索しています..."
            DOWNLOADED_ARCHIVE=""

            # よくあるダウンロード場所を確認
            for location in "$TEMP_DIR" "$HOME/Downloads" "$HOME" "$HOME/Documents"; do
                FOUND=$(find "$location" -maxdepth 1 -name "Voicepeak-linux64.zip" 2>/dev/null | head -1)
                if [ -n "$FOUND" ]; then
                    DOWNLOADED_ARCHIVE="$FOUND"
                    echo -e "${GREEN}✓${NC} アーカイブが見つかりました: $DOWNLOADED_ARCHIVE"
                    break
                fi
            done

            if [ -n "$DOWNLOADED_ARCHIVE" ]; then
                echo "アーカイブを ~/Voicepeak に解凍しています..."
                unzip -q "$DOWNLOADED_ARCHIVE" -d "$HOME"
                if [ $? -eq 0 ]; then
                    echo -e "${GREEN}✓${NC} 解凍完了"
                    VOICEPEAK_EXISTS=true
                else
                    echo -e "${RED}✗${NC} 解凍に失敗しました"
                fi
            else
                echo -e "${YELLOW}!${NC} アーカイブが見つかりませんでした"
                echo "手動で ~/Voicepeak に展開してください"
            fi

            cd "$HOME" || exit 1
            rm -rf "$TEMP_DIR"
        else
            # 手動ダウンロードの指示
            echo ""
            echo "以下のURLからVOICEPEAKをダウンロードしてください："
            echo "$DOWNLOAD_URL"
            echo ""
            echo "ダウンロード後、アーカイブを ~/Voicepeak に展開してください。"
            echo ""
            read -p "~/Voicepeakに展開が完了したら Enterキーを押してください..."
        fi
    fi
fi

# ~/Voicepeakの存在を再確認
if [ ! -d "$HOME/Voicepeak" ]; then
    echo -e "${RED}✗${NC} エラー: ~/Voicepeakが見つかりません。"
    echo "VOICEPEAKを ~/Voicepeak に展開してから、再度実行してください。"
    exit 1
fi

if [ ! -f "$HOME/Voicepeak/voicepeak" ]; then
    echo -e "${RED}✗${NC} エラー: ~/Voicepeak/voicepeakバイナリが見つかりません。"
    echo "VOICEPEAKが正しく展開されていることを確認してください。"
    exit 1
fi

echo -e "${GREEN}✓${NC} VOICEPEAKファイルの確認が完了しました。"

# パッケージのビルドとインストール
echo ""
echo -e "${BLUE}ステップ 2:${NC} パッケージのビルドとインストール"
echo "----------------------------------------"

cd "$AUR_PACKAGE_DIR" || exit 1

echo "パッケージをビルドしています..."
rm -f *.pkg.tar.zst
if ! makepkg -sf --noconfirm; then
    echo -e "${RED}✗${NC} エラー: パッケージのビルドに失敗しました。"
    exit 1
fi

echo ""
echo "パッケージをインストールしています..."
PACKAGE=$(ls -t voicepeak-*.pkg.tar.zst | head -1)

if [ -z "$PACKAGE" ]; then
    echo -e "${RED}✗${NC} エラー: パッケージファイルが見つかりません。"
    exit 1
fi

if ! sudo pacman -U "$PACKAGE" --noconfirm; then
    echo -e "${RED}✗${NC} エラー: パッケージのインストールに失敗しました。"
    exit 1
fi

echo ""
echo -e "${BLUE}ステップ 3:${NC} 後処理"
echo "----------------------------------------"

# ~/Voicepeakを削除するか確認
echo ""
read -p "インストールが完了しました。~/Voicepeakフォルダを削除しますか? [Y/n] " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Nn]$ ]]; then
    echo "~/Voicepeakを削除しています..."
    rm -rf "$HOME/Voicepeak"
    echo -e "${GREEN}✓${NC} 削除完了"
fi

echo ""
echo -e "${GREEN}=========================================${NC}"
echo -e "${GREEN}  インストール完了！${NC}"
echo -e "${GREEN}=========================================${NC}"
echo ""
echo "VOICEPEAKの起動方法："
echo "  - ターミナル: ${BLUE}voicepeak${NC}"
echo "  - wofi: ${BLUE}Super+R${NC} → \"VOICEPEAK\"と検索"
echo ""
echo "データの保存場所："
echo "  - 実行ファイル: ${BLUE}~/.local/share/voicepeak/${NC}"
echo "  - 設定ファイル: ${BLUE}~/.local/share/voicepeak/usersettings/${NC}"
echo ""
