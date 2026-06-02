#!/bin/bash
# Usage: ./calculateCPI.sh ./resources/allCoursesTaken.csv ./resources/letterGradeToNumber.csv
#
# CPI = sum(credits_i * grade_points_i) / sum(credits_i)
# All courses included (Minor, Honor, Additional Learning too).

COURSES="$1"
GRADE_MAP="$2"

awk -v RS="\r\n|\n" '
BEGIN {
    FS = ","
    total_weighted = 0
    total_credits  = 0
}

function trim(s) {
    gsub(/^[ \t\r]+|[ \t\r]+$/, "", s)
    return s
}

# First file: letterGradeToNumber.csv
# Expected columns: letterGrade, gradePoint
NR == FNR {
    if (FNR == 1) { next }
    grade = trim($1)
    gp    = trim($2) + 0
    grade_point[grade] = gp
    next
}

# Second file: allCoursesTaken.csv
# Columns: Year($1), Semester($2), Code($3), Name($4), Credits($5), Tag($6), letterGrade($7)
{
    if (FNR == 1) { next }   # skip header
    credits      = trim($5) + 0
    letter_grade = trim($7)

    if (letter_grade in grade_point) {
        gp = grade_point[letter_grade]
        total_weighted += credits * gp
        total_credits  += credits
    }
}

END {
    if (total_credits > 0) {
        printf "%.4f\n", total_weighted / total_credits
    } else {
        print "0.0000"
    }
}
' "$GRADE_MAP" "$COURSES"
