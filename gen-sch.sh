#!/bin/sh

#
# Usage: ./gen/schem.sh <sch> <new pdf location>
#
# Generates a PDF schematic of the provided schematic, 
# (this can be multiple pages for a hierarchical schematic)
#

set -e

die() {
    echo "$*"
    exit 1
}

if [ $# -ne 2 ]; then
    die "Usage: $0 <sch> <new pdf location>"
fi

sch="$1"
ext="$(basename "$sch" | sed 's/^.*\.\(.*\)$/\1/')"
[ "$ext" = "kicad_sch" ] || die "File extension must be 'kicad_sch'"
[ -f "$sch" ] || die "sch '$sch' doesn't exist"

new_location="$2"
[ -z "$new_location" ] && die "Invalid (empty) location for new zip: '$new_location'"
echo "$new_location" | grep ".pdf$" >/dev/null || die "The output zip name should end in .pdf, not '$new_location'"

kicad-cli sch export pdf --no-background-color --output "$new_location" "$sch"
