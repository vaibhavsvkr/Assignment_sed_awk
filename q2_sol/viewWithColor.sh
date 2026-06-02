#!/bin/bash
# Usage: ./viewWithColor.sh outputA ./resources/creditsRequirements.csv

OUTPUT_A="$1"
CREDITS_REQ="$2"

RESOURCES_DIR="$(dirname "$CREDITS_REQ")"
source "$RESOURCES_DIR/defineColors.sh"

# Export all color variables so awk can access via ENVIRON
export BLACK_FONT RED_FONT GREEN_FONT YELLOW_FONT BLUE_FONT MAGENTA_FONT CYAN_FONT WHITE_FONT
export BLACK_BACKGROUND RED_BACKGROUND GREEN_BACKGROUND YELLOW_BACKGROUND BLUE_BACKGROUND MAGENTA_BACKGROUND CYAN_BACKGROUND WHITE_BACKGROUND
export RESET="$(tput sgr0)"

awk -v RESET="$RESET" '
BEGIN {
    FS = ","
}

function trim(s) {
    gsub(/^[ \t\r]+|[ \t\r]+$/, "", s)
    return s
}

# First file: creditsRequirements.csv
# columns: tag, credits, color_FONT, color_BACKGROUND
NR == FNR {
    if (FNR == 1) { next }
    tag  = trim($1)
    font = trim($3) "_FONT"        # e.g. CYAN_FONT
    bg   = trim($4) "_BACKGROUND"  # e.g. BLACK_BACKGROUND
    color_start[tag] = ENVIRON[bg] ENVIRON[font]
    next
}

# Second file: outputA
{
    line = $0
    gsub(/\r/, "", line)

    # Separator and header lines (first 3 lines): print as-is
    if (FNR <= 3) {
        print line
        next
    }

    # Tag is field 5 of 6, each 20 wide → cols 81-100
    tag_field = substr(line, 81, 20)
    gsub(/^[ \t]+|[ \t]+$/, "", tag_field)

    if (tag_field in color_start) {
        printf "%s%s%s\n", color_start[tag_field], line, RESET
    } else {
        print line
    }
}
' "$CREDITS_REQ" "$OUTPUT_A"