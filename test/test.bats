#!/usr/bin/env bats

source ../archive_clippings_functions.sh

TEMP=./_temp_clips.txt
CLIPS=./My\ Clippings.txt

TITLE=$(extract_title "$CLIPS")
TITLE_F=$(format_title "$TITLE")

@test "Extract title correctly" { 
	[ "$TITLE" = "21 Lessons, for the 21st Century (Noah-Harari; Yuval: Book 2)" ]
}

@test "Format filename from title correctly" { 	
	[ "$TITLE_F" = "21-Lessons-for-the-21st-Century-Noah-Harari-Yuval-Book-2.txt" ]
}

@test "Extract clippings correctly" { 	
	extract_clips "$TITLE" "$CLIPS" > "$TEMP"
	touch "$TITLE_F"
	format_clips "$TEMP" > "$TITLE_F"
	
	diff --ignore-all-space \
		target.txt \
		$TITLE_F
	[ $? -eq 0 ]
	rm $TITLE_F $TEMP
}
