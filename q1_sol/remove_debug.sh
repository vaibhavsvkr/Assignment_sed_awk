#!/bin/bash
# Usage: ./remove_debug.sh <src_dir> <output>
# Removes all lines containing "// TEMPDEBUG:" from every *.c and *.h
# file under src/, recursively. Handles leading whitespace.
# Creates <output>/debug_removed_count.txt with total removed line count.
# Robust to paths containing spaces.

SRC_DIR="${1:-./q1_inputs/src}"
OUTPUT="$2"

mkdir -p "$OUTPUT"

total=0

while IFS= read -r -d '' file; do
    # Count lines matching // TEMPDEBUG: (with optional leading whitespace)
    count=$(grep -c '// TEMPDEBUG:' "$file" 2>/dev/null || true)
    if [ "$count" -gt 0 ]; then
        sed -i '/\/\/ TEMPDEBUG:/d' "$file"
        total=$((total + count))
    fi
done < <(find "$SRC_DIR" -type f \( -name "*.c" -o -name "*.h" \) -print0)

echo "$total" > "$OUTPUT/debug_removed_count.txt"
