#!/bin/bash

# BDドライブの状態を確認して表示・切り替え

DEVICE="/dev/sr0"

get_status() {
    if [ ! -e "$DEVICE" ]; then
        echo '{"text": "󰌹", "tooltip": "BDドライブが見つかりません", "class": "missing"}'
        exit 0
    fi
    
    PERMS=$(stat -c %a "$DEVICE" 2>/dev/null)
    
    if [ "$PERMS" = "0" ]; then
        # 無効（Protonゲーム用）
        echo '{"text": "󰨞", "tooltip": "BDドライブ: 無効\n(Protonゲーム用)\nクリックで有効化", "class": "disabled"}'
    else
        # 有効（BD再生用）
        echo '{"text": "󰗮", "tooltip": "BDドライブ: 有効\n(BD再生可能)\nクリックで無効化", "class": "enabled"}'
    fi
}

toggle() {
    if [ ! -e "$DEVICE" ]; then
        notify-send "BDドライブ" "デバイスが見つかりません" -i dialog-error
        exit 1
    fi
    
    PERMS=$(stat -c %a "$DEVICE" 2>/dev/null)
    
    if [ "$PERMS" = "0" ]; then
        # 有効化
        pkexec chmod 660 "$DEVICE" && \
        notify-send "BDドライブ" "有効化しました\nVLCなどでBD再生可能です" -i media-optical
    else
        # 無効化
        pkexec chmod 000 "$DEVICE" && \
        notify-send "BDドライブ" "無効化しました\nProtonゲームが正常動作します" -i emblem-locked
    fi
}

case "$1" in
    toggle)
        toggle
        ;;
    *)
        get_status
        ;;
esac
