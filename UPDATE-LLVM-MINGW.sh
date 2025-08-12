#!/bin/bash

set -euo pipefail

# Constantes
SCRIPT_PATH="$(realpath "$0")"
SCRIPT_DIR="$(dirname "$SCRIPT_PATH")"
scripts_dir="/opt/llvm-mingw"
llvm_mingw_dir="$scripts_dir/llvm-mingw"
bin_dir="$llvm_mingw_dir/bin"
dest_dir="/usr/local/bin"
hook_path="/etc/apt/apt.conf.d/99update-llvm-mingw.conf"

# Obtener JSON de GitHub release "nightly"
json=$(sudo curl -s --fail https://api.github.com/repos/mstorsjo/llvm-mingw/releases/tags/nightly)

# Usar script Python para extraer la URL
download_url=$(echo "$json" | sudo "$SCRIPT_DIR/GET-NAME-LLVM-MINGW-RELEASE.py")

# Descargar el archivo
echo "Descargando: $download_url"
sudo curl -LO "$download_url"

# Extraerlo en el directorio correspondiente
echo "Instalando..."
sudo rm -rf "$llvm_mingw_dir"
sudo mkdir -p "$llvm_mingw_dir"
sudo tar -xf ./llvm-mingw-*.tar.xz -C "$llvm_mingw_dir" --strip-components=1





# Crear Wrappers
mkdir -p "$dest_dir"

# Función para crear wrapper
crear_wrapper() {
  local cmdname="$1"
  local target="$2"
  local wrapper_path="$dest_dir/$cmdname"

  cat > "$wrapper_path" <<EOF
#!/bin/bash
exec "$target" "\$@"
EOF
  chmod +x "$wrapper_path"
  echo "Wrapper creado: $wrapper_path -> $target"
}

# Obtener todos los clang, clang++, gcc y g++ que hay en bin_dir
for bin in "$bin_dir"/*; do
  basebin=$(basename "$bin")

  if [[ "$basebin" =~ clang$ || "$basebin" =~ clang\+\+$ || "$basebin" =~ gcc$ || "$basebin" =~ g\+\+$ ]]; then
    # Crear wrapper con el mismo nombre
    crear_wrapper "$basebin" "$bin"
  fi
done

echo
echo "Todos los wrappers se crearon en: $dest_dir"
echo "Agregá esta carpeta a tu PATH para usarlos fácilmente:"
echo "  export PATH=\"$dest_dir:\$PATH\""






# Copiando scripts
if [[ "$SCRIPT_DIR" != "$scripts_dir" ]]; then
    echo "Copiando archivos a $scripts_dir..."

    # Crear el directorio si no existe
    sudo mkdir -p "$scripts_dir"

    # Copiar el script actual
    sudo cp "$SCRIPT_PATH" "$scripts_dir/"
    sudo cp "$SCRIPT_DIR/GET-NAME-LLVM-MINGW-RELEASE.py" "$scripts_dir/"
fi

# Automatizando actualizaciones
echo "Automatizando actualizaciones"
if [[ -f "$hook_path" ]]; then
    echo "✅ Ya existe el hook en '$hook_path'. No se realiza ninguna acción."
else
    echo "🔧 Creando hook en '$hook_path'..."

    # Crear el hook con contenido
    sudo tee "$hook_path" > /dev/null <<EOF
APT::Update::Post-Invoke { "sudo bash '$scripts_dir/UPDATE-LLVM-MINGW.sh' || true"; };
EOF

    echo "✅ Hook creado exitosamente."
fi

# Eliminar archivos temporales
echo "Eliminando archivos temporales"
sudo rm -f ./llvm-mingw-*.tar.xz
sudo rm -rf ./__pycache__