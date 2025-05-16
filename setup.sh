#!/bin/bash

# কালার কোড
RED="\e[1;31m"
GREEN="\e[1;32m"
YELLOW="\e[1;33m"
RESET="\e[0m"

# ফোল্ডার স্ট্রাকচার তৈরি
create_folders() {
    echo -e "\n${YELLOW}[*] Creating folder structure...${RESET}"
    mkdir -p templates modules logs captures
    chmod 755 templates modules logs captures
    echo -e "${GREEN}[✓] Folders created successfully${RESET}"
}

# ডিপেন্ডেন্সি ইন্সটল
install_dependencies() {
    echo -e "\n${YELLOW}[*] Installing required packages...${RESET}"
    if [[ -f /data/data/com.termux/files/usr/bin/pkg ]]; then
        pkg update -y
        pkg install -y php wget unzip curl
    else
        sudo apt-get update
        sudo apt-get install -y php wget unzip curl
    fi
    echo -e "${GREEN}[✓] Dependencies installed successfully${RESET}"
}

# টানেলিং টুলস সেটআপ
setup_tunneling() {
    echo -e "\n${YELLOW}[*] Setting up tunneling tools...${RESET}"
    
    # Ngrok সেটআপ
    if [ ! -f "ngrok" ]; then
        wget https://bin.equinox.io/c/4VmDzA7iaHb/ngrok-stable-linux-amd64.zip
        unzip ngrok-stable-linux-amd64.zip
        chmod +x ngrok
        rm -rf ngrok-stable-linux-amd64.zip
    fi
    
    # Cloudflared সেটআপ
    if [ ! -f "cloudflared" ]; then
        wget https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64
        chmod +x cloudflared-linux-amd64
        mv cloudflared-linux-amd64 cloudflared
    fi
    
    echo -e "${GREEN}[✓] Tunneling tools setup completed${RESET}"
}

# ফাইল পারমিশন সেট
set_permissions() {
    echo -e "\n${YELLOW}[*] Setting file permissions...${RESET}"
    chmod +x camphish.sh
    chmod +x modules/*.sh
    chmod 644 templates/*.php
    echo -e "${GREEN}[✓] Permissions set successfully${RESET}"
}

# মেইন সেটআপ
main_setup() {
    echo -e "${YELLOW}[*] Starting CamPhish setup...${RESET}"
    
    create_folders
    install_dependencies
    setup_tunneling
    set_permissions
    
    echo -e "\n${GREEN}[✓] Setup completed successfully!${RESET}"
    echo -e "${YELLOW}[*] Run './camphish.sh' to start the tool${RESET}"
}

# সেটআপ শুরু
main_setup
