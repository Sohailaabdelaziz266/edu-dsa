#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

ASSIGNMENT="${1:-SWB-04}"
STUDENT_FILTER="${2:-}"
BUILD_DIR="${ROOT_DIR}/build/${ASSIGNMENT}"

"${ROOT_DIR}/scripts/build.sh" "$ASSIGNMENT"

if [[ -n "$STUDENT_FILTER" ]]; then
    echo "Running tests for submission id: ${STUDENT_FILTER}"
    ctest --test-dir "$BUILD_DIR" -R "_${STUDENT_FILTER}$" --output-on-failure
else
    echo "Running tests for all submissions in assignment=${ASSIGNMENT}"
    ctest --test-dir "$BUILD_DIR" --output-on-failure
fi

echo "All selected tests passed."
