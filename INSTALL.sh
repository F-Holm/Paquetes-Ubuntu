#!/usr/bin/env bash

# Evitar ejecución como root
if [ "$EUID" -eq 0 ]; then
  echo "Este script no debe ejecutarse como root." >&2
  exit 1
fi

# Constantes
SCRIPT_PATH="$(realpath "$0")"
SCRIPT_DIR="$(dirname "$SCRIPT_PATH")"
SCRIPTS_DIR="$SCRIPT_DIR/Scripts"

# Ingresar datos al inicio del script para minimizar interacción
autodestruccion=""
while true; do
    read -p "¿Quieres que se elimine el directorio del script ('$SCRIPT_DIR') al finalizar? (y/n): " response
    case "$response" in
        [yY])
            autodestruccion="yes"
            echo "El directorio '$SCRIPT_DIR' será eliminado al finalizar el script."
            break
            ;;
        [nN])
            autodestruccion="no"
            echo "El directorio '$SCRIPT_DIR' NO será eliminado al finalizar el script."
            break
            ;;
        *)
            echo "Entrada no válida. Por favor, ingresa 'y' para sí o 'n' para no."
            ;;
    esac
    echo
done
read -rp "Mail de GitHub: " mail_github
read -rp "Nombre de usuario de GitHub: " nombre_usuario_github

bash "$SCRIPTS_DIR/Base.sh"
bash "$SCRIPTS_DIR/Config.sh"

bash "$SCRIPTS_DIR/Programacion/Powershell.sh"
bash "$SCRIPTS_DIR/Programacion/Utils.sh"

bash "$SCRIPTS_DIR/Misc/Utils.sh"

bash "$SCRIPTS_DIR/C++/C++.sh"
bash "$SCRIPTS_DIR/DB/DB.sh"
bash "$SCRIPTS_DIR/Java/Java.sh"
bash "$SCRIPTS_DIR/JavaScript/JavaScript.sh"
bash "$SCRIPTS_DIR/Python/Python.sh"

# Fuera de WSL2
if [ -z "$WSL_INTEROP" ]; then
    bash "$SCRIPTS_DIR/Programacion/VSCode.sh"
    bash "$SCRIPTS_DIR/Programacion/Docker.sh"
    
    bash "$SCRIPTS_DIR/Misc/Chrome.sh"
    bash "$SCRIPTS_DIR/Misc/Steam.sh"
    bash "$SCRIPTS_DIR/Misc/Discord.sh"
fi

# Final
sudo apt update
sudo apt install -f
sudo apt upgrade -y
sudo apt autoremove -y

# GitHub
git config --global user.email "$mail_github"
git config --global user.name "$nombre_usuario_github"
ssh-keygen -t ed25519 -C "$mail_github"
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519
echo
echo "----------------------------------------"
echo clave SSH de GitHub:
echo
echo "----------------------------------------"
cat ~/.ssh/id_ed25519.pub
echo "----------------------------------------"
echo

# Autodestrucción
if [ "$autodestruccion" == "yes" ]; then
    rm -rf "$SCRIPT_DIR"
    if [ $? -eq 0 ]; then
        echo "Directorio '$SCRIPT_DIR' eliminado exitosamente."
    else
        echo "Error al intentar eliminar el directorio '$SCRIPT_DIR'."
    fi
else
    echo "El directorio '$SCRIPT_DIR' no será eliminado."
fi
