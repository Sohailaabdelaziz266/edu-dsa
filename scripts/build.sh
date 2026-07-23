#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

ASSIGNMENT="${1:-SWB-04}"
STUDENT="${2:-example-student}"
SUBMISSION="${3:-}"
BUILD_SUFFIX="${ASSIGNMENT}/${STUDENT}"
BUILD_DIR="${ROOT_DIR}/build/${BUILD_SUFFIX}"

CMAKE_ARGS=(
    -S .
    -B "$BUILD_DIR"
    -DEDU_ASSIGNMENT="$ASSIGNMENT"
)

if [[ -n "$SUBMISSION" ]]; then
    CMAKE_ARGS+=(-DEDU_SUBMISSION="$SUBMISSION")
    BUILD_SUFFIX="${SUBMISSION//\//-}"
    BUILD_DIR="${ROOT_DIR}/build/${BUILD_SUFFIX}"
    CMAKE_ARGS=(-S . -B "$BUILD_DIR" -DEDU_ASSIGNMENT="$ASSIGNMENT" -DEDU_SUBMISSION="$SUBMISSION")
fi

echo "Building assignment=${ASSIGNMENT} submission=${SUBMISSION:-${ASSIGNMENT}/${STUDENT}}"

cmake "${CMAKE_ARGS[@]}"
cmake --build "$BUILD_DIR" --parallel

echo "Build succeeded: $BUILD_DIR"
