#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

ASSIGNMENT="${1:?Error: Assignment argument is required}"
STUDENT_FILTER="${2}"

echo "Building assignment=${ASSIGNMENT} using Makefile"


if [[ -n "${STUDENT_FILTER}" ]]; then
    make MAIN_DIR="${ASSIGNMENT}/${STUDENT_FILTER}"


else
    make MAIN_DIR="${ASSIGNMENT}"
fi

echo "Build preparation succeeded."
