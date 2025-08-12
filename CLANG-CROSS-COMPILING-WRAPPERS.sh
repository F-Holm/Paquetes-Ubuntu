#!/bin/bash

set -eux
sudo mkdir -p /usr/local/bin

# i686
sudo echo '#!/bin/sh' > /usr/local/bin/i686-linux-gnu-clang
sudo echo 'exec clang --target=i686-linux-gnu --sysroot=/usr/i686-linux-gnu "$@"' >> /usr/local/bin/i686-linux-gnu-clang
sudo chmod +x /usr/local/bin/i686-linux-gnu-clang

sudo echo '#!/bin/sh' > /usr/local/bin/i686-linux-gnu-clang++
sudo echo 'exec clang++ --target=i686-linux-gnu --sysroot=/usr/i686-linux-gnu "$@"' >> /usr/local/bin/i686-linux-gnu-clang++
sudo chmod +x /usr/local/bin/i686-linux-gnu-clang++

# ARM 64-bit
sudo echo '#!/bin/sh' > /usr/local/bin/aarch64-linux-gnu-clang
sudo echo 'exec clang --target=aarch64-linux-gnu --sysroot=/usr/aarch64-linux-gnu "$@"' >> /usr/local/bin/aarch64-linux-gnu-clang
sudo chmod +x /usr/local/bin/aarch64-linux-gnu-clang

sudo echo '#!/bin/sh' > /usr/local/bin/aarch64-linux-gnu-clang++
sudo echo 'exec clang++ --target=aarch64-linux-gnu --sysroot=/usr/aarch64-linux-gnu "$@"' >> /usr/local/bin/aarch64-linux-gnu-clang++
sudo chmod +x /usr/local/bin/aarch64-linux-gnu-clang++

# ARM 32-bit
sudo echo '#!/bin/sh' > /usr/local/bin/arm-linux-gnueabihf-clang
sudo echo 'exec clang --target=arm-linux-gnueabihf --sysroot=/usr/arm-linux-gnueabihf "$@"' >> /usr/local/bin/arm-linux-gnueabihf-clang
sudo chmod +x /usr/local/bin/arm-linux-gnueabihf-clang

sudo echo '#!/bin/sh' > /usr/local/bin/arm-linux-gnueabihf-clang++
sudo echo 'exec clang++ --target=arm-linux-gnueabihf --sysroot=/usr/arm-linux-gnueabihf "$@"' >> /usr/local/bin/arm-linux-gnueabihf-clang++
sudo chmod +x /usr/local/bin/arm-linux-gnueabihf-clang++