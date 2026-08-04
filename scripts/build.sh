#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

ASSIGNMENT="${1:-SWB-04}"
STUDENT_FILTER="${2:-}"

echo "Building assignment=${ASSIGNMENT} using Makefile"


if [[ -n "${EDU_STUDENTS:-}" ]]; then
    make test MAIN_DIR="${ASSIGNMENT}/${STUDENT_FILTER}"


else
    make test MAIN_DIR="${ASSIGNMENT}"
fi

echo "Build and test preparation succeeded."
