#!/bin/bash

set -euo pipefail

# Obtener JSON de GitHub release "nightly"
json=$(curl -s https://api.github.com/repos/mstorsjo/llvm-mingw/releases/tags/nightly)

# Usar script Python para extraer la URL
download_url=$(echo "$json" | ./GET-NAME-LLVM-MINGW-RELEASE.py)

# Descargar el archivo
echo "Descargando: $download_url"
curl -LO "$download_url"

# Extraerlo en el directorio correspondiente
llvm_mingw_dir="/opt/llvm-mingw"
sudo rm -rf "$llvm_mingw_dir"
sudo mkdir -p "$llvm_mingw_dir"
sudo tar -xf ./llvm-mingw-*.tar.xz -C "$llvm_mingw_dir" --strip-components=1
rm ./llvm-mingw-*.tar.xz

# Agregarlo al path del sistema

# Limpiar caché de Python compilado
rm -rf ./__pycache__
