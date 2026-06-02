#!/bin/bash
# Usage: ./viewWithColor.sh outputA ./resources/creditsRequirements.csv

OUTPUT_A="$1"
CREDITS_REQ="$2"

# Load color variable definitions into this shell's environment
source ./resources/defineColors.sh

# Pass all environment variables into awk via ENVIRON (awk reads env automatically).
# Build the color map in awk from creditsRequirements.csv, then apply to outputA.

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
    if (FNR == 1) { next }   # skip header
    tag    = trim($1)
    # credits = trim($2)   # not needed here
    font   = trim($3)        # variable name like CYAN_FONT
    bg     = trim($4)        # variable name like BLACK_BACKGROUND

    # Resolve variable names to ANSI codes via ENVIRON
    color_start[tag] = ENVIRON[bg] ENVIRON[font]
    next
}

# Second file: outputA lines
{
    line = $0
    gsub(/\r/, "", line)

    # Separator / header lines: print as-is
    if (line ~ /^-+$/ || FNR == 1) {
        print line
        next
    }

    # Tag occupies columns 81-100 (5th field, 0-indexed: fields are 1-20, 21-40,
    # 41-60, 61-80, 81-100, 101-120 for 6 fields of width 20)
    tag_field = substr(line, 81, 20)
    gsub(/^[ \t]+|[ \t]+$/, "", tag_field)

    if (tag_field in color_start) {
        printf "%s%s%s\n", color_start[tag_field], line, RESET
    } else {
        print line
    }
}
' "$CREDITS_REQ" "$OUTPUT_A"
