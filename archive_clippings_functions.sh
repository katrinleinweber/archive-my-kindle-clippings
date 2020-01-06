#!/usr/bin/env bash

extract_title() {
    grep --invert-match --max-count=1 "^\s*$" "$1"
}

format_title() {
    # Prepare title string as kebap-case-filename
    echo "$1" | \
        perl -pe 's/[[:punct:]]//g' | \
        perl -pe 's/\W+/-/g' | \
        perl -pe 's/-+$//' | \
        perl -pe 's/\b$/.txt/'
}

extract_clips() {
    grep --invert-match "$1" "$2"
}

format_clips() {
    # Remove original separators & timestamps
    # Convert descriptions into short ASCIDOC headings
    perl -pe 's/^=+//g' "$1" | \
        perl -pe 's/ \|[^[:punct:]]+,[ .\w]+(:\d+)+( \w+)?\s+//gi' | \
        perl -pe 's/- [A-Z][a-z]+ /\r\n=== /g'
}
