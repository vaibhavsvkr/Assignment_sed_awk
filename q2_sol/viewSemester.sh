#!/bin/bash
# Usage: ./viewSemester.sh outputB <Semester> <Year>
# Year in outputB has .0 stripped already, so compare as-is

OUTPUT_B="$1"
SEMESTER="$2"
YEAR="$3"

# Print header + separator (first 2 lines)
head -2 "$OUTPUT_B"

# Filter and sort by course code (cols 41-60)
tail -n +3 "$OUTPUT_B" | awk -v sem="$SEMESTER" -v yr="$YEAR" '
{
    line = $0
    # Strip ANSI codes for field extraction
    plain = line
    gsub(/\033\[[0-9;]*m/, "", plain)

    year_f = substr(plain,  1, 20); gsub(/^[ \t]+|[ \t]+$/, "", year_f)
    sem_f  = substr(plain, 21, 20); gsub(/^[ \t]+|[ \t]+$/, "", sem_f)
    code_f = substr(plain, 41, 20); gsub(/^[ \t]+|[ \t]+$/, "", code_f)

    if (year_f == yr && sem_f == sem) {
        print code_f "\t" line
    }
}
' | sort -k1,1 | cut -f2-