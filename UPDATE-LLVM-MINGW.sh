#!/bin/bash

set -euo pipefail

# Obtener JSON de GitHub release "nightly"
json=$(curl -s https://api.github.com/repos/mstorsjo/llvm-mingw/releases/tags/nightly)

echo "$json"

# Usar script Python para extraer la URL
#download_url=$(echo "$json" | ./get_latest_url.py)

# Descargar el archivo
#echo "Descargando: $download_url"
#curl -LO "$download_url"

# Limpiar caché de Python compilado
#rm -rf ./__pycache__
