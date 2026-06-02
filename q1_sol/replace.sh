#!/bin/bash
# Usage: ./replace.sh <src_dir> <output>
# Replaces #include <oldlib.h> with #include <newlib.h>
# ONLY in *.c and *.h files that also contain a call to init_adapter().
# Backup files get extension .bak
# Creates <output>/patched_files.txt listing all modified files.

SRC_DIR="${1:-./q1_inputs/src}"
OUTPUT="$2"

mkdir -p "$OUTPUT"

> "$OUTPUT/patched_files.txt"

# Find all .c and .h files recursively
find "$SRC_DIR" -type f \( -name "*.c" -o -name "*.h" \) | while IFS= read -r file; do
    # Check both conditions in one grep pass:
    #   1) file contains #include <oldlib.h>
    #   2) file contains init_adapter()
    if grep -qF '#include <oldlib.h>' "$file" && grep -qF 'init_adapter()' "$file"; then
        # Create backup and do in-place replacement
        sed -i.bak 's|#include <oldlib\.h>|#include <newlib.h>|g' "$file"
        echo "$file" >> "$OUTPUT/patched_files.txt"
    fi
done
