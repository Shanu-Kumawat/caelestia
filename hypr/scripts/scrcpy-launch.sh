#!/usr/bin/env bash
set -euo pipefail

if ! command -v scrcpy >/dev/null 2>&1; then
    notify-send "scrcpy" "scrcpy is not installed"
    exit 1
fi

if ! command -v adb >/dev/null 2>&1; then
    notify-send "scrcpy" "adb is not installed"
    exit 1
fi

adb start-server >/dev/null 2>&1 || true

if ! adb devices | awk 'NR > 1 && $2 == "device" { found = 1 } END { exit(found ? 0 : 1) }'; then
    notify-send "scrcpy" "No USB-debugging device detected"
    exit 1
fi

mode="${1:-dev}"
if [[ $# -gt 0 ]]; then
    shift
fi

common_flags=(
    -d
    --window-title="scrcpy-phone"
    --no-audio
    --stay-awake
    --turn-screen-off
)

case "$mode" in
    dev)
        # Fast and responsive for coding/debugging with good visual fidelity.
        exec scrcpy "${common_flags[@]}" \
            --video-codec=h264 \
            --video-bit-rate=12M \
            --max-fps=60 \
            --max-size=1920 \
            --video-buffer=0 \
            "$@"
        ;;
    quality)
        # Highest on-screen quality for UI checks and demos.
        exec scrcpy "${common_flags[@]}" \
            --video-codec=h264 \
            --video-bit-rate=30M \
            --max-fps=60 \
            --max-size=0 \
            "$@"
        ;;
    *)
        notify-send "scrcpy" "Unknown mode: $mode (use: dev | quality)"
        exit 1
        ;;
esac
