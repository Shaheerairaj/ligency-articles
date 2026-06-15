#!/bin/bash
# Count words and characters in a markdown file
# Usage: ./count.sh <file.md>

FILE="${1:-DRAFT.md}"

if [[ ! -f "$FILE" ]]; then
  echo "File not found: $FILE"
  exit 1
fi

# Strip markdown syntax for a cleaner word count
PLAIN=$(sed \
  -e 's/```[^`]*```//g' \
  -e 's/`[^`]*`//g' \
  -e 's/^#+[[:space:]]*//' \
  -e 's/^\s*[-*][[:space:]]*//' \
  -e 's/\!\[.*\]([^)]*)//' \
  -e 's/\[.*\]([^)]*)//' \
  -e 's/[*_>#|]//g' \
  "$FILE")

WORDS=$(echo "$PLAIN" | wc -w)
CHARS_NO_SPACES=$(echo "$PLAIN" | tr -d ' \n\t' | wc -c)
CHARS_WITH_SPACES=$(cat "$FILE" | wc -c)
LINES=$(wc -l < "$FILE")
PARAGRAPHS=$(grep -c '^$' "$FILE" || true)

echo "File: $FILE"
echo "------------------------------"
printf "Words:                  %6d\n" "$WORDS"
printf "Characters (no spaces): %6d\n" "$CHARS_NO_SPACES"
printf "Characters (w/ spaces): %6d\n" "$CHARS_WITH_SPACES"
printf "Lines:                  %6d\n" "$LINES"
printf "Blank lines (≈paras):   %6d\n" "$PARAGRAPHS"
echo "------------------------------"
printf "Avg word length:        %6.1f chars\n" "$(echo "scale=1; $CHARS_NO_SPACES / $WORDS" | bc)"
printf "Est. reading time:      %6.1f min  (250 wpm)\n" "$(echo "scale=1; $WORDS / 250" | bc)"
