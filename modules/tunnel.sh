#!/bin/bash

# কালার কোড
RED="\e[1;31m"
GREEN="\e[1;32m"
YELLOW="\e[1;33m"
RESET="\e[0m"

# Ngrok টানেল
start_ngrok() {
    echo -e "\n${YELLOW}[*] Starting Ngrok server...${RESET}"
    ./ngrok http 8080 > /dev/null 2>&1 &
    sleep 5
    
    link=$(curl -s -N http://127.0.0.1:4040/api/tunnels | grep -o "https://[0-9a-z]*\.ngrok.io")
    if [[ -n $link ]]; then
        echo -e "${GREEN}[✓] Ngrok URL generated${RESET}"
        echo "$link" > logs/tunnel_url.txt
        return 0
    else
        echo -e "${RED}[!] Ngrok error! Try again.${RESET}"
        return 1
    fi
}

# Cloudflared টানেল
start_cloudflared() {
    echo -e "\n${YELLOW}[*] Starting Cloudflared server...${RESET}"
    ./cloudflared tunnel --url http://localhost:8080 > logs/cloudflared.log 2>&1 &
    sleep 5
    
    link=$(grep -o 'https://[-0-9a-z]*\.trycloudflare.com' "logs/cloudflared.log")
    if [[ -n $link ]]; then
        echo -e "${GREEN}[✓] Cloudflared URL generated${RESET}"
        echo "$link" > logs/tunnel_url.txt
        return 0
    else
        echo -e "${RED}[!] Cloudflared error! Try again.${RESET}"
        return 1
    fi
}

# টানেল স্টপ
stop_tunnel() {
    pkill -f ngrok
    pkill -f cloudflared
    rm -f logs/tunnel_url.txt
    rm -f logs/cloudflared.log
    echo -e "${GREEN}[✓] Tunnel stopped${RESET}"
}
