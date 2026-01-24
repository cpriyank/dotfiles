#!/bin/bash
# Context Menu TTS - Read selected text aloud using Kokoro-TTS
set -euo pipefail
export PATH="/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin:$PATH"
KOKORO_URL="http://localhost:8880"
KOKORO_DIR="$HOME/.kokoro-tts"
TEMP_AUDIO="/tmp/context-menu-tts-$$.mp3"
MAX_WAIT=60
notify() {
    osascript -e "display notification \"$2\" with title \"$1\""
}
is_server_running() {
    curl -s --max-time 2 "$KOKORO_URL/v1/models" > /dev/null 2>&1
}
start_server() {
    notify "Kokoro TTS" "Starting TTS server..."
    cd "$KOKORO_DIR"
    nohup ./start-kokoro.sh > /tmp/kokoro-tts.log 2>&1 &
    local elapsed=0
    while ! is_server_running; do
        sleep 2
        elapsed=$((elapsed + 2))
        if [ $elapsed -ge $MAX_WAIT ]; then
            notify "Kokoro TTS" "Error: Server failed to start"
            exit 1
        fi
    done
    notify "Kokoro TTS" "Server started"
}
cleanup() { rm -f "$TEMP_AUDIO"; }
trap cleanup EXIT
TEXT=$(cat)
if [ -z "$TEXT" ]; then
    notify "Kokoro TTS" "Error: No text selected"
    exit 1
fi
MAX_CHARS=10000
if [ ${#TEXT} -gt $MAX_CHARS ]; then
    TEXT="${TEXT:0:$MAX_CHARS}"
fi
if ! is_server_running; then
    start_server
fi
notify "Kokoro TTS" "Generating speech..."
HTTP_CODE=$(curl -s -w "%{http_code}" -o "$TEMP_AUDIO" \
    "$KOKORO_URL/v1/audio/speech" \
    -H "Content-Type: application/json" \
    -d "$(jq -n --arg text "$TEXT" '{
        model: "kokoro",
        voice: "af_bella",
        input: $text,
        response_format: "mp3",
        speed: 1.0
    }')")
if [ "$HTTP_CODE" != "200" ] || [ ! -s "$TEMP_AUDIO" ]; then
    notify "Kokoro TTS" "Error: Failed to generate speech (HTTP $HTTP_CODE)"
    exit 1
fi
/usr/bin/afplay "$TEMP_AUDIO"
