set -euo pipefail
API_URL="https://engine.pair.gov.sg/v1/messages"
MODEL="claude-sonnet-4-5-20250929-v1:rsn"
notify() {
    osascript -e "display notification \"$2\" with title \"$1\""
}
get_api_key() {
    security find-generic-password -a "$USER" -s "anthropic-api-key" -w 2>/dev/null
}
TEXT=$(cat)
if [ -z "$TEXT" ]; then
    notify "Summarize" "Error: No text selected"
    exit 1
fi
API_KEY=$(get_api_key)
if [ -z "$API_KEY" ]; then
    notify "Summarize" "Error: API key not found in Keychain"
    osascript -e 'display dialog "API key not found.\n\nRun this command to add it:\nsecurity add-generic-password -a \"$USER\" -s \"anthropic-api-key\" -w \"YOUR_KEY\"" with title "Summarize Setup" buttons {"OK"} default button "OK"'
    exit 1
fi
notify "Summarize" "Summarizing text..."
PROMPT="Please provide a concise summary of the following text. Focus on the key points and main ideas:\n\n$TEXT"
RESPONSE=$(curl -s "$API_URL" \
    -H "x-api-key: $API_KEY" \
    -H "anthropic-version: 2023-06-01" \
    -H "content-type: application/json" \
    -d "$(jq -n --arg prompt "$PROMPT" --arg model "$MODEL" '{
        model: $model,
        max_tokens: 1024,
        messages: [{role: "user", content: $prompt}]
    }')")
# Extract the summary from response
SUMMARY=$(echo "$RESPONSE" | jq -r '.content[0].text // .error.message // "Failed to get summary"')
if [ -z "$SUMMARY" ] || [ "$SUMMARY" = "null" ]; then
    notify "Summarize" "Error: Failed to get summary"
    exit 1
fi
# Copy to clipboard
echo "$SUMMARY" | pbcopy
# Show notification (truncated if long)
DISPLAY_TEXT="$SUMMARY"
if [ ${#DISPLAY_TEXT} -gt 200 ]; then
    DISPLAY_TEXT="${DISPLAY_TEXT:0:197}..."
fi
notify "Summary Copied" "$DISPLAY_TEXT"
