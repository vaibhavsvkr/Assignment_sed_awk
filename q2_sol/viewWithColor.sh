#!/bin/bash
# Usage: ./viewWithColor.sh outputA ./resources/creditsRequirements.csv
# creditsRequirements.csv columns: tag, credits, color_FONT, color_BACKGROUND
# color_FONT values like CYAN → variable name CYAN_FONT in defineColors.sh
# color_BACKGROUND values like BLACK → variable name BLACK_BACKGROUND

OUTPUT_A="$1"
CREDITS_REQ="$2"

source ./resources/defineColors.sh

awk -v RESET="$RESET" '
BEGIN {
    FS = ","
}

function trim(s) {
    gsub(/^[ \t\r]+|[ \t\r]+$/, "", s)
    return s
}

# First file: creditsRequirements.csv
NR == FNR {
    if (FNR == 1) { next }
    tag  = trim($1)
    font = trim($3) "_FONT"        # e.g. CYAN_FONT
    bg   = trim($4) "_BACKGROUND"  # e.g. BLACK_BACKGROUND
    # Resolve via ENVIRON (shell already exported them via source)
    color_start[tag] = ENVIRON[bg] ENVIRON[font]
    next
}

# Second file: outputA
{
    line = $0
    gsub(/\r/, "", line)

    # Header and separator lines: print as-is
    if (FNR <= 2) {
        print line
        next
    }

    # Tag is field 5 of 6, each field 20 wide → cols 81-100
    tag_field = substr(line, 81, 20)
    gsub(/^[ \t]+|[ \t]+$/, "", tag_field)

    if (tag_field in color_start) {
        printf "%s%s%s\n", color_start[tag_field], line, RESET
    } else {
        print line
    }
}
' "$CREDITS_REQ" "$OUTPUT_A"