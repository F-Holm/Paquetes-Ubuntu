#!/bin/bash

# Evitar ejecución como root
if [ "$EUID" -eq 0 ]; then
  echo "Este script no debe ejecutarse como root." >&2
  exit 1
fi

# Constantes
SCRIPT_PATH="$(realpath "$0")"
SCRIPT_DIR="$(dirname "$SCRIPT_PATH")"

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

# Hacer que deje de aparecer mensaje diario
touch ~/.hushlogin

# Paquetes fundamentales
sudo apt install -y curl wget git

# MySQL
sudo wget https://dev.mysql.com/get/mysql-apt-config_0.8.32-1_all.deb
sudo dpkg -i mysql-apt-config_0.8.32-1_all.deb
sudo apt update
sudo apt install -y mysql-server
sudo mysql_secure_installation
sudo apt install -y mysql-workbench-community
sudo rm mysql-apt-config_0.8.32-1_all.deb

# MongoDB
sudo curl -fsSL https://pgp.mongodb.com/server-7.0.asc | sudo gpg -o /usr/share/keyrings/mongodb-server-7.0.gpg --dearmor
sudo echo "deb [ signed-by=/usr/share/keyrings/mongodb-server-7.0.gpg ] https://repo.mongodb.org/apt/ubuntu jammy/mongodb-org/7.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-7.0.list
sudo apt update
sudo apt install -y mongodb-org
sudo systemctl start mongod
sudo systemctl enable mongod
sudo wget https://downloads.mongodb.com/compass/mongodb-compass_1.45.4_amd64.deb
sudo apt install -y ./mongodb-compass_1.45.4_amd64.deb
sudo rm ./mongodb-compass_1.45.4_amd64.deb

# Powershell
sudo wget -q https://packages.microsoft.com/config/ubuntu/$(lsb_release -rs)/packages-microsoft-prod.deb
sudo dpkg -i packages-microsoft-prod.deb
sudo apt update
sudo apt install -y powershell
sudo rm ./packages-microsoft-prod.deb

# DBeaver
sudo wget https://dbeaver.io/files/25.0.3/dbeaver-ce_25.0.3_amd64.deb
sudo apt install -y ./dbeaver-ce_25.0.3_amd64.deb
sudo rm ./dbeaver-ce_25.0.3_amd64.deb

# VS Code
sudo wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/microsoft.gpg > /dev/null
sudo echo "deb [arch=amd64] https://packages.microsoft.com/repos/code stable main" | sudo tee /etc/apt/sources.list.d/vscode.list
sudo apt update
sudo apt install -y code

# Chrome
sudo wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo apt install -y ./google-chrome-stable_current_amd64.deb
sudo rm ./google-chrome-stable_current_amd64.deb

# C++
sudo apt install -y build-essential gcc g++ clang clang-format clang-tidy clangd clang-tools cmake make doxygen gdb graphviz ninja-build valgrind llvm ccache gcc-i686-linux-gnu g++-i686-linux-gnu gcc-arm-linux-gnueabihf g++-arm-linux-gnueabihf gcc-aarch64-linux-gnu g++-aarch64-linux-gnu mingw-w64

# Extra
sudo apt install -y openssl libssl-dev python3-pip python3-venv perl p7zip-full gimp codeblocks zeal vlc unattended-upgrades

# JetBrains
sudo snap install intellij-idea-community --classic
sudo snap install webstorm --classic
sudo snap install pycharm-community --classic

# Steam
sudo wget https://cdn.akamai.steamstatic.com/client/installer/steam.deb
sudo apt install -y ./steam.deb
sudo rm ./steam.deb

# Discord
sudo wget -O discord.deb "https://discord.com/api/download?platform=linux&format=deb"
sudo apt install -y ./discord.deb
sudo rm ./discord.deb

# Docker - NO USAR EN WSL

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
