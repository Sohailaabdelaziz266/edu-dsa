#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

ASSIGNMENT="${1:-SWB-04}"
STUDENT="${2:-example-student}"
SUBMISSION="${3:-}"

if [[ -n "$SUBMISSION" ]]; then
    SUBMISSION_DIR="$SUBMISSION"
else
    SUBMISSION_DIR="${ASSIGNMENT}/${STUDENT}"
fi

if [[ ! -d "$SUBMISSION_DIR/inc" || ! -d "$SUBMISSION_DIR/src" ]]; then
    echo "Submission not found or missing inc/src: $SUBMISSION_DIR" >&2
    exit 1
fi

echo "Running cpplint on: $SUBMISSION_DIR"

mapfile -t source_files < <(
    find "$SUBMISSION_DIR/inc" "$SUBMISSION_DIR/src" -type f \( -name '*.c' -o -name '*.h' \) | sort
)

if [[ ${#source_files[@]} -eq 0 ]]; then
    echo "No C source/header files found in $SUBMISSION_DIR" >&2
    exit 1
fi

if command -v cpplint >/dev/null 2>&1; then
    CPPLINT=(cpplint)
elif python3 -m cpplint --version >/dev/null 2>&1; then
    CPPLINT=(python3 -m cpplint)
else
    echo "cpplint not found. Install with: pip install cpplint" >&2
    exit 1
fi

"${CPPLINT[@]}" "${source_files[@]}"

echo "Lint passed."
