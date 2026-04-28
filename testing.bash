#!/bin/bash

if [ -z "$1" ]; then
    echo "Usage: $0 <script_or_executable>"
    exit 1
fi

INPUT="$1"
EXEC_NAME="$(basename "${INPUT%.*}")"
EXT="${INPUT##*.}"
DATA_DIR="$(dirname "$0")/data"
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

if [ ! -f "$INPUT" ]; then
    echo "Error: '$INPUT' does not exist."
    exit 1
fi

if [ "$EXT" = "py" ]; then
    RUN_CMD="python3 $INPUT"
else
    if [ ! -x "$INPUT" ]; then
        chmod +x "$INPUT"
    fi
    if [[ "$INPUT" != */* ]]; then
        INPUT="./$INPUT"
    fi
    RUN_CMD="$INPUT"
fi

PASS=0
FAIL=0

for INPUT_FILE in "$DATA_DIR"/${EXEC_NAME}*.in; do
    BASE="${INPUT_FILE%.in}"
    ANS_FILE="${BASE}.ans"
    TEST_NAME="$(basename "$BASE")"

    if [ ! -f "$ANS_FILE" ]; then
        echo "Skipping '$TEST_NAME': no .ans file found."
        continue
    fi

    ACTUAL_OUTPUT=$(${RUN_CMD} < "$INPUT_FILE" 2>/dev/null)
    EXPECTED_OUTPUT=$(cat "$ANS_FILE")

    if [ "$ACTUAL_OUTPUT" = "$EXPECTED_OUTPUT" ]; then
        echo -e "${GREEN}Correct!${NC} [$TEST_NAME]"
        PASS=$((PASS + 1))
    else
        echo -e "${RED}Wrong!${NC} [$TEST_NAME]"
        echo "  Expected:"
        echo "$EXPECTED_OUTPUT" | sed 's/^/    /'
        echo "  Got:"
        echo "$ACTUAL_OUTPUT" | sed 's/^/    /'
        FAIL=$((FAIL + 1))
    fi
done

echo ""
echo "Results: $PASS passed, $FAIL failed."