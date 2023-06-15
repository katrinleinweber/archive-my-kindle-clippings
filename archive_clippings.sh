#!/usr/bin/env bash

TEMP="$HOME"/Documents/Kindle-clippings/_temp_clips.txt

# Get file from Kindle
DEV_PATH=/Volumes/Kindle/documents
CLIPS="$DEV_PATH"/My\ Clippings.txt
cp "$CLIPS" "./_ori_clips-$(date -u +"%y%m%d-%H%M").txt"
# learned on https://stackoverflow.com/a/7216394/4341322

extract_title() {
    grep --invert-match --max-count=1 "^\s*$" "$1"
}

format_title() {
    # Prepare title string as kebap-case-filename
    echo "$1" | \
        perl -pe 's/\W+/-/g' | \
        perl -pe 's/^-+//g' | \
        perl -pe 's/\b(-+)?$/.txt/'
}

extract_clips() {
    grep --invert-match "$1" "$2"
}

format_clips() {
    # Remove original separators & timestamps
    # Convert descriptions into short ASCIDOC headings
    perl -pe 's/^=+//g' "$1" | \
        perl -pe 's/ \|[^[:punct:]]+,[ .\w]+(:\d+)+( \w+)?\s+//gi' | \
        perl -pe 's/- [A-Z][a-z]+ /\r\n== /g' | \
        perl -pe 's/^== N/==== N/g'
}

# Remove title & save clips into temp file
TITLE=$(extract_title "$CLIPS")
extract_clips "$TITLE" "$CLIPS" > "$TEMP"

TITLE_F=$(format_title "$TITLE")
touch "$TITLE_F"
format_clips "$TEMP" >> "$TITLE_F"
open "$TITLE_F"

# Clean up locally & on device
mv ./*_clips* "$HOME"/.Trash/
echo "" > "$CLIPS"

# Copy clippings onto device for review
cp "$TITLE_F" "$DEV_PATH"
