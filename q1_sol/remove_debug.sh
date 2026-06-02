#!/bin/bash
# Usage: ./remove_debug.sh <src_dir> <output>
# Removes all lines beginning with "// TEMPDEBUG:" from every *.c and *.h
# file under src/, recursively.
# Creates <output>/debug_removed_count.txt with total removed line count.
# Robust to paths containing spaces.

SRC_DIR="${1:-./q1_inputs/src}"
OUTPUT="$2"

mkdir -p "$OUTPUT"

total=0

# Use -print0 / read -d '' to handle spaces in paths safely
while IFS= read -r -d '' file; do
    # Count matching lines before removal
    count=$(grep -c '^// TEMPDEBUG:' "$file" 2>/dev/null || true)
    if [ "$count" -gt 0 ]; then
        # In-place deletion of lines starting with // TEMPDEBUG:
        sed -i '/^\/\/ TEMPDEBUG:/d' "$file"
        total=$((total + count))
    fi
done < <(find "$SRC_DIR" -type f \( -name "*.c" -o -name "*.h" \) -print0)

echo "$total" > "$OUTPUT/debug_removed_count.txt"
