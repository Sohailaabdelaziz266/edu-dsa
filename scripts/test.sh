#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

ASSIGNMENT="${1:-SWB-04}"
STUDENT_FILTER="${2:-}"


if [[ -n "$STUDENT_FILTER" ]]; then
    make test MAIN_DIR="${ASSIGNMENT}/${STUDENT_FILTER}"
else
    make test MAIN_DIR="${ASSIGNMENT}"
fi


if [[ -n "$STUDENT_FILTER" ]]; then
    echo "Running tests for submission id: ${STUDENT_FILTER}"
    make run_tests MAIN_DIR="${ASSIGNMENT}/${STUDENT_FILTER}"
else
    echo "Running tests for all submissions in assignment=${ASSIGNMENT}"
    make run_tests MAIN_DIR="${ASSIGNMENT}"
fi

echo "All selected tests passed."