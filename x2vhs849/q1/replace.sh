#!/bin/bash
# Usage: ./replace.sh <src_dir> <output>
# Replaces #include <oldlib.h> with #include <newlib.h>
# ONLY in *.c and *.h files that also contain a call to init_adapter (any form).
# Backup files get extension .bak
# Creates <output>/patched_files.txt listing all modified files.

SRC_DIR="${1:-./q1_inputs/src}"
OUTPUT="$2"

mkdir -p "$OUTPUT"
> "$OUTPUT/patched_files.txt"

find "$SRC_DIR" -type f \( -name "*.c" -o -name "*.h" \) | while IFS= read -r file; do
    if grep -qF '#include <oldlib.h>' "$file" && grep -q 'init_adapter' "$file"; then
        sed -i.bak 's|#include <oldlib\.h>|#include <newlib.h>|g' "$file"
        echo "$file" >> "$OUTPUT/patched_files.txt"
    fi
done
