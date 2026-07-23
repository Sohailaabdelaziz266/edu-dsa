#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

ASSIGNMENT="${1:-SWB-04}"
STUDENT="${2:-example-student}"
SUBMISSION="${3:-}"

if [[ -n "$SUBMISSION" ]]; then
    BUILD_DIR="${ROOT_DIR}/build/${SUBMISSION//\//-}"
else
    BUILD_DIR="${ROOT_DIR}/build/${ASSIGNMENT}/${STUDENT}"
fi

"${ROOT_DIR}/scripts/build.sh" "$ASSIGNMENT" "$STUDENT" "$SUBMISSION"

echo "Running tests for assignment=${ASSIGNMENT} in $BUILD_DIR"
ctest --test-dir "$BUILD_DIR" --output-on-failure

echo "All tests passed."
