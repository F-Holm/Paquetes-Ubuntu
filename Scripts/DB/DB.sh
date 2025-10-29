#!/usr/bin/env bash

SCRIPT_PATH="$(realpath "$0")"
SCRIPT_DIR="$(dirname "$SCRIPT_PATH")"

bash "$SCRIPT_DIR/DBeaver.sh"
bash "$SCRIPT_DIR/MongoDB.sh"
bash "$SCRIPT_DIR/MySQL.sh"
