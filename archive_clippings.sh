#!/usr/bin/env bash

TEMP="$HOME"/Documents/Kindle-clippings/_temp_clips.txt

# Get file from Kindle
CLIPS=/Volumes/Kindle/documents/My\ Clippings.txt
cp "$CLIPS" "./_ori_clips-$(date -u +"%y%m%d-%H%M").txt"
# learned on https://stackoverflow.com/a/7216394/4341322

# Remove title & save into temp file
TITLE=$(grep --invert-match --max-count=1 "^\s*$" "$CLIPS")
grep --invert-match "$TITLE" "$CLIPS" > "$TEMP"

# Prepare title string as kebap-case-filename
TITLE=$(echo "$TITLE" | \
		perl -pe 's/[[:punct:]]//g' | \
		perl -pe 's/\W+/-/g' | \
		perl -pe 's/-+$//g')
touch "$TITLE".txt

# Remove original separators & timestamps
# Convert descriptions into short ASCIDOC headings
perl -pe 's/^=+//g' "$TEMP"_1 | \
	perl -pe 's/ \|[ \wü]+,[ .\w]+(:\d+)+( \w+)?\s+//gi' | \
	perl -pe 's/- (Your|Ihre) /\r\n=== /gi' >> \
	"$TITLE".txt
open "$TITLE"

# Clean up locally & on device
mv ./*_clips* "$HOME"/.Trash/
echo "" > "$CLIPS"
