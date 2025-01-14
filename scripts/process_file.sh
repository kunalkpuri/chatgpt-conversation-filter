#!/bin/bash

if [ "$#" -lt 3 ]; then
    echo "Usage: $0 <input_file> <keyword> <output_file>"
    exit 1
fi

INPUT_FILE=$1
KEYWORD=$2
OUTPUT_FILE=$3

if ! command -v jq &> /dev/null; then
    echo "jq is required but not installed. Please install jq and try again."
    exit 1
fi

jq --arg keyword "$KEYWORD" '
  .[] | select(
    (.title | test($keyword; "i")) or
    (
      .mapping |
      to_entries[] |
      select(.value.message.content.parts? != null) |
      .value.message.content.parts[] |
      select(type == "string" and test($keyword; "i"))
    )
  ) | {
    id: (.conversation_id // "No ID"),
    title: (.title // "No Title"),
    url: "https://chat.openai.com/chat/\(.conversation_id // "NoID")"
  }
' "$INPUT_FILE" | jq -s 'unique_by(.id)' > "$OUTPUT_FILE"

echo "Filtered conversations saved to '$OUTPUT_FILE'."

