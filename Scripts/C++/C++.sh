#!/usr/bin/env bash

SCRIPT_PATH="$(realpath "$0")"
SCRIPT_DIR="$(dirname "$SCRIPT_PATH")"

#bash "$SCRIPT_DIR/Clang-wrappers-cross-compile.sh"
bash "$SCRIPT_DIR/LLVM-Mingw.sh"
bash "$SCRIPT_DIR/Utils.sh"
bash "$SCRIPT_DIR/GCC-cross-compile.sh"
