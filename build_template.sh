#!/usr/bin/env bash
set -e

mkdir -p out

OUT_FILE="out/template.rb"

echo "# frozen_string_literal: true" > "$OUT_FILE"
echo "" >> "$OUT_FILE"
echo "# ==============================================================================" >> "$OUT_FILE"
echo "# Rails Application Template: rails-core (GENERATED FILE - DO NOT EDIT DIRECTLY)" >> "$OUT_FILE"
echo "# Source files: template_parts/*.rb" >> "$OUT_FILE"
echo "# ==============================================================================" >> "$OUT_FILE"
echo "" >> "$OUT_FILE"

for part in template_parts/*.rb; do
  if [ -f "$part" ]; then
    echo "# --- Part: $(basename "$part") ---" >> "$OUT_FILE"
    cat "$part" >> "$OUT_FILE"
    echo "" >> "$OUT_FILE"
  fi
done

ruby -c "$OUT_FILE" > /dev/null || { echo "Error: Syntax error in $OUT_FILE"; exit 1; }

echo "==> Template successfully compiled to $OUT_FILE"
