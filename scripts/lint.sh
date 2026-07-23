#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

if command -v cpplint >/dev/null 2>&1; then
    CPPLINT=(cpplint)
elif python3 -m cpplint --version >/dev/null 2>&1; then
    CPPLINT=(python3 -m cpplint)
else
    echo "cpplint not found. Install with: pip install cpplint" >&2
    exit 1
fi

lint_submission() {
    local submission_dir="$1"

    if [[ ! -d "$submission_dir/inc" || ! -d "$submission_dir/src" ]]; then
        echo "Submission not found or missing inc/src: $submission_dir" >&2
        return 1
    fi

    echo "Running cpplint on: $submission_dir"

    mapfile -t source_files < <(
        find "$submission_dir/inc" "$submission_dir/src" -type f \( -name '*.c' -o -name '*.h' \) | sort
    )

    if [[ ${#source_files[@]} -eq 0 ]]; then
        echo "No C source/header files found in $submission_dir" >&2
        return 1
    fi

    "${CPPLINT[@]}" "${source_files[@]}"
}

discover_submissions() {
    local assignment="$1"
    local assignment_dir="${ROOT_DIR}/${assignment}"

    if [[ ! -d "$assignment_dir" ]]; then
        echo "Assignment directory not found: $assignment" >&2
        return 1
    fi

    for entry in "$assignment_dir"/*; do
        [[ -d "$entry" ]] || continue
        lint_submission "$entry"
    done

    if [[ -d "${ROOT_DIR}/dev/reference/inc" && -d "${ROOT_DIR}/dev/reference/src" ]]; then
        lint_submission "${ROOT_DIR}/dev/reference"
    fi
}

ASSIGNMENT="${1:-SWB-04}"
STUDENT="${2:-}"

if [[ -n "$STUDENT" ]]; then
    lint_submission "${ROOT_DIR}/${ASSIGNMENT}/${STUDENT}"
else
    discover_submissions "$ASSIGNMENT"
fi

echo "Lint passed."
