#!/bin/bash

set -euo pipefail

# ==============================
#  CONFIGURACIÓN Y CONSTANTES
# ==============================
SCRIPT_PATH="$(realpath "$0")"
SCRIPT_DIR="$(dirname "$SCRIPT_PATH")"
scripts_dir="/opt/llvm-mingw"
llvm_mingw_dir="$scripts_dir/llvm-mingw"
bin_dir="$llvm_mingw_dir/bin"
dest_dir="/usr/local/bin"
hook_path="/etc/apt/apt.conf.d/99update-llvm-mingw.conf"
last_run_file="$scripts_dir/.last_run"

# ==============================
#  PARÁMETROS
# ==============================
force=false
if [[ "${1:-}" == "-f" ]]; then
    force=true
    echo "⚠️  Modo forzado activado: se ignora la restricción de 7 días."
fi

# ==============================
#  CONTROL DE FRECUENCIA
# ==============================
if [[ -f "$last_run_file" && "$force" == false ]]; then
    last_run=$(cat "$last_run_file")
    now=$(date +%s)
    diff=$(( now - last_run ))

    if (( diff < 7*24*60*60 )); then
        echo "⏳ El script update-llvm-mingw ya se ejecutó en los últimos 7 días. Usa '-f' para forzar."
        exit 0
    fi
fi

# ==============================
#  ACTUALIZACIÓN DE LLVM-MINGW
# ==============================
echo "🚀 Iniciando actualización de llvm-mingw..."

# Obtener JSON de GitHub release "nightly"
json=$(sudo curl -s --fail https://api.github.com/repos/mstorsjo/llvm-mingw/releases/tags/nightly)

# Usar script Python para extraer la URL
download_url=$(echo "$json" | sudo "$SCRIPT_DIR/GET-NAME-LLVM-MINGW-RELEASE.py")

# Descargar el archivo
echo "📦 Descargando: $download_url"
sudo curl -LO "$download_url"

# Extraerlo en el directorio correspondiente
echo "📂 Instalando..."
sudo rm -rf "$llvm_mingw_dir"
sudo mkdir -p "$llvm_mingw_dir"
sudo tar -xf ./llvm-mingw-*.tar.xz -C "$llvm_mingw_dir" --strip-components=1

# Crear Wrappers
mkdir -p "$dest_dir"
echo "🔗 Creando symlinks en $dest_dir..."
sudo ln -s $bin_dir/llvm-windres $dest_dir 2>/dev/null || true
sudo ln -s $bin_dir/mingw32-common.cfg $dest_dir 2>/dev/null || true
sudo ln -s $bin_dir/x86_64-w64-* $dest_dir 2>/dev/null || true
sudo ln -s $bin_dir/i686-w64-* $dest_dir 2>/dev/null || true
sudo ln -s $bin_dir/aarch64-w64-* $dest_dir 2>/dev/null || true
sudo ln -s $bin_dir/arm64ec-w64-* $dest_dir 2>/dev/null || true
sudo ln -s $bin_dir/armv7-w64-* $dest_dir 2>/dev/null || true

# Copiando scripts
if [[ "$SCRIPT_DIR" != "$scripts_dir" ]]; then
    echo "📁 Copiando archivos a $scripts_dir..."
    sudo mkdir -p "$scripts_dir"
    sudo cp "$SCRIPT_PATH" "$scripts_dir/"
    sudo cp "$SCRIPT_DIR/GET-NAME-LLVM-MINGW-RELEASE.py" "$scripts_dir/"
fi

# Automatizando actualizaciones
echo "⚙️  Verificando hook de APT..."
if [[ -f "$hook_path" ]]; then
    echo "✅ Ya existe el hook en '$hook_path'."
else
    echo "🪛 Creando hook en '$hook_path'..."
    sudo tee "$hook_path" > /dev/null <<EOF
APT::Update::Post-Invoke { "sudo bash '$scripts_dir/UPDATE-LLVM-MINGW.sh' || true"; };
EOF
    echo "✅ Hook creado exitosamente."
fi

# Copiando archivos faltantes
sudo cp "$llvm_mingw_dir/lib/clang/22/include/mm_malloc.h" "$llvm_mingw_dir/x86_64-w64-mingw32/include/mm_malloc.h"

# Eliminar archivos temporales
echo "🧹 Eliminando archivos temporales..."
sudo rm -f ./llvm-mingw-*.tar.xz
sudo rm -rf ./__pycache__

# ==============================
#  GUARDAR FECHA DE EJECUCIÓN
# ==============================
echo "🕒 Guardando fecha de última ejecución..."
sudo mkdir -p "$scripts_dir"
date +%s | sudo tee "$last_run_file" > /dev/null

echo "✅ Actualización completada correctamente."
