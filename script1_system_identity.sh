#!/bin/bash
# =============================================================================
# Script 1: System Identity Report
# Author: Kabir verma | Course: Open Source Software | VIT Bhopal University
# Description: Displays a detailed identity report of the Linux system,
#              including kernel info, user details, uptime, and OS license.
# =============================================================================

# --- Color codes for formatted output ---
RED='\033[0;31m'
GREEN='\033[0;32m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
BOLD='\033[1m'
RESET='\033[0m'

# --- Student and project variables ---
STUDENT_NAME="Kabir verma"                  # Student name
REGISTRATION_NO="24bcg10012"        #Registration number
SOFTWARE_CHOICE="Git"               # Chosen open-source software
COURSE="Open Source Software"       # Course name

# --- Collect system information using command substitution ---
KERNEL=$(uname -r)                        # Linux kernel version
ARCH=$(uname -m)                          # System architecture
USER_NAME=$(whoami)                       # Current logged-in user
HOME_DIR=$HOME                            # Home directory of the user
UPTIME=$(net stats srv | grep "Statistics since" | cut -d ' ' -f3-)CURRENT_DATE=$(date '+%A, %d %B %Y')     # Current date in readable format
CURRENT_TIME=$(date '+%H:%M:%S %Z')      # Current time with timezone
HOSTNAME=$(hostname)                      # System hostname

# --- Detect Linux distribution name ---
# /etc/os-release is the standard file for distro identification
if [ -f /etc/os-release ]; then
    DISTRO=$(grep -w "PRETTY_NAME" /etc/os-release | cut -d= -f2 | tr -d '"')
else
    DISTRO="Unknown Linux Distribution"
fi

# --- Determine OS license ---
# Most Linux distros are based on the Linux kernel (GPL v2)
# and ship with GPL-compatible userland tools
OS_LICENSE="GNU General Public License v2 (GPLv2)"

# --- RAM and CPU information ---
TOTAL_RAM=$(free -h | awk '/^Mem:/{print $2}')   # Total RAM
TOTAL_RAM=$(systeminfo | grep "Total Physical Memory" | cut -d ":" -f2 | sed 's/ //g')# --- Display the report ---
echo -e "${BOLD}${CYAN}"
echo "╔══════════════════════════════════════════════════════════════╗"
echo "║            OPEN SOURCE AUDIT — SYSTEM IDENTITY              ║"
echo "╚══════════════════════════════════════════════════════════════╝"
echo -e "${RESET}"

echo -e "${YELLOW}  Student  :${RESET} $STUDENT_NAME"
echo -e "${YELLOW}  Software :${RESET} $SOFTWARE_CHOICE"
echo -e "${YELLOW}  Course   :${RESET} $COURSE"
echo ""

echo -e "${BOLD}${GREEN}── System Information ─────────────────────────────────────────${RESET}"
echo -e "  Hostname         : ${CYAN}$HOSTNAME${RESET}"
echo -e "  Distribution     : ${CYAN}$DISTRO${RESET}"
echo -e "  Kernel Version   : ${CYAN}$KERNEL${RESET}"
echo -e "  Architecture     : ${CYAN}$ARCH${RESET}"
echo -e "  CPU              : ${CYAN}$CPU_MODEL${RESET}"
echo -e "  Total RAM        : ${CYAN}$TOTAL_RAM${RESET}"
echo ""

echo -e "${BOLD}${GREEN}── User Session ───────────────────────────────────────────────${RESET}"
echo -e "  Logged-in User   : ${CYAN}$USER_NAME${RESET}"
echo -e "  Home Directory   : ${CYAN}$HOME_DIR${RESET}"
echo -e "  System Uptime    : ${CYAN}$UPTIME${RESET}"
echo -e "  Date             : ${CYAN}$CURRENT_DATE${RESET}"
echo -e "  Time             : ${CYAN}$CURRENT_TIME${RESET}"
echo ""

echo -e "${BOLD}${GREEN}── License Information ────────────────────────────────────────${RESET}"
echo -e "  OS License       : ${CYAN}$OS_LICENSE${RESET}"
echo -e "  This Linux system is powered by the Linux Kernel,"
echo -e "  released under the GPL v2 — meaning anyone can read,"
echo -e "  modify, and redistribute the source code freely."
echo ""

echo -e "${BOLD}${CYAN}══════════════════════════════════════════════════════════════${RESET}"
echo -e "  \"Free software is a matter of liberty, not price.\""
echo -e "                                        — Richard Stallman"
echo -e "${BOLD}${CYAN}══════════════════════════════════════════════════════════════${RESET}"
