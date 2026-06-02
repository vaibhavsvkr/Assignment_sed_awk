#!/bin/bash
# Usage: ./local_filter.sh <input> <output>

INPUT="$1"
OUTPUT="$2"

mkdir -p "$OUTPUT"

awk '
/ERROR/ {
    # Extract code value from the field that starts with "code="
    code = ""
    for (i = 1; i <= NF; i++) {
        if ($i ~ /^code=/) {
            split($i, a, "=")
            code = a[2]
            break
        }
    }
    print $1, $2, code
}
' "$INPUT" > "$OUTPUT/error_lines.txt"
