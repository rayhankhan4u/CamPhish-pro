#!/bin/bash

# কালার কোড
RED="\e[1;31m"
GREEN="\e[1;32m"
YELLOW="\e[1;33m"
RESET="\e[0m"

# ক্লিনআপ ফাংশন
cleanup() {
    echo -e "\n${YELLOW}[*] Cleaning up...${RESET}"
    
    # প্রসেস কিল
    pkill -f "php -S"
    pkill -f "ngrok"
    pkill -f "cloudflared"
    
    # টেম্পোরারি ফাইল ক্লিনআপ
    rm -f logs/cloudflared.log
    rm -f logs/tunnel_url.txt
    
    echo -e "${GREEN}[✓] Cleanup completed${RESET}"
}

# লগ ক্লিনআপ
cleanup_logs() {
    echo -e "\n${YELLOW}[*] Cleaning logs...${RESET}"
    rm -rf logs/*
    echo -e "${GREEN}[✓] Logs cleaned${RESET}"
}

# ক্যাপচার ক্লিনআপ
cleanup_captures() {
    echo -e "\n${YELLOW}[*] Cleaning captures...${RESET}"
    read -p $'\e[1;32m[?] Are you sure? (y/n): \e[0m' confirm
    if [[ "$confirm" == "y" || "$confirm" == "Y" ]]; then
        rm -rf captures/*
        echo -e "${GREEN}[✓] Captures cleaned${RESET}"
    else
        echo -e "${YELLOW}[*] Operation cancelled${RESET}"
    fi
}

# সম্পূর্ণ ক্লিনআপ
cleanup_all() {
    cleanup
    cleanup_logs
    cleanup_captures
}
