#!/bin/zsh
set -euo pipefail

if [[ $# -ne 1 ]]; then
  echo "Usage: zsh scaffold-guide.sh /absolute/output/path" >&2
  exit 2
fi

SCRIPT_DIR=${0:A:h}
TEMPLATE_DIR="$SCRIPT_DIR/../assets/app-template"
OUTPUT_DIR=${1:A}

if [[ -e "$OUTPUT_DIR" ]]; then
  echo "Refusing to overwrite existing path: $OUTPUT_DIR" >&2
  exit 3
fi

mkdir -p "$OUTPUT_DIR"
cp -R "$TEMPLATE_DIR/." "$OUTPUT_DIR/"

echo "$OUTPUT_DIR"
