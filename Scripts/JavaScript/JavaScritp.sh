#!/usr/bin/env bash

SCRIPT_PATH="$(realpath "$0")"
SCRIPT_DIR="$(dirname "$SCRIPT_PATH")"

bash "$SCRIPT_DIR/Utils.sh"
bash "$SCRIPT_DIR/WebStorm.sh"
