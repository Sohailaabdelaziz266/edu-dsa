#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

ASSIGNMENT="${1:-SWB-04}"
BUILD_DIR="${ROOT_DIR}/build/${ASSIGNMENT}"

CMAKE_ARGS=(-S . -B "$BUILD_DIR" -DEDU_ASSIGNMENT="$ASSIGNMENT")

if [[ -n "${EDU_STUDENTS:-}" ]]; then
    CMAKE_ARGS+=(-DEDU_STUDENTS="$EDU_STUDENTS")
fi

if [[ -n "${EDU_EXTRA_SUBMISSIONS:-}" ]]; then
    CMAKE_ARGS+=(-DEDU_EXTRA_SUBMISSIONS="$EDU_EXTRA_SUBMISSIONS")
fi

echo "Building assignment=${ASSIGNMENT} (one test suite, one binary per submission)"

cmake "${CMAKE_ARGS[@]}"
cmake --build "$BUILD_DIR" --parallel

echo "Build succeeded: $BUILD_DIR"
