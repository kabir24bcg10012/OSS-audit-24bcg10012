#!/bin/bash
# =============================================================================
# Script 2: FOSS Package Inspector
# Author: Kabir | Course: Open Source Software | VIT Bhopal University
# Description: Checks if the chosen software (Git) is installed, displays
#              version and license info, and uses a case statement to
#              provide philosophical notes on popular FOSS packages.
# =============================================================================

# --- Color codes ---
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
BOLD='\033[1m'
RESET='\033[0m'

# --- Target package (our chosen software) ---
PACKAGE="git"

# --- Helper function to detect package manager ---
detect_pkg_manager() {
    if command -v rpm &>/dev/null; then
        echo "rpm"
    elif command -v dpkg &>/dev/null; then
        echo "dpkg"
    else
        echo "unknown"
    fi
}

# --- Helper function to get version ---
get_version() {
    if command -v "$1" &>/dev/null; then
        "$1" --version 2>/dev/null | head -1
    else
        echo "Not found"
    fi
}

# --- Print header ---
echo -e "${BOLD}${CYAN}"
echo "╔══════════════════════════════════════════════════════════════╗"
echo "║               FOSS PACKAGE INSPECTOR                        ║"
echo "╚══════════════════════════════════════════════════════════════╝"
echo -e "${RESET}"

PKG_MANAGER=$(detect_pkg_manager)

# --- Check if Git is installed ---
# Using 'command -v' which is POSIX-compliant and works regardless of package manager
echo -e "${BOLD}${GREEN}── Checking: $PACKAGE ─────────────────────────────────────────${RESET}"

if command -v "$PACKAGE" &>/dev/null; then
    echo -e "  Status    : ${GREEN}✔ INSTALLED${RESET}"
    echo -e "  Version   : ${CYAN}$(get_version $PACKAGE)${RESET}"
    echo -e "  Location  : ${CYAN}$(which $PACKAGE)${RESET}"
    echo ""

    # --- Try to get more info from the package manager ---
    echo -e "${BOLD}${GREEN}── Package Metadata ──────────────────────────────────────────${RESET}"

    if [ "$PKG_MANAGER" = "rpm" ]; then
        # RPM-based systems (Fedora, RHEL, CentOS)
        rpm -qi git 2>/dev/null | grep -E "^(Name|Version|License|Summary|URL)" | \
            awk -F': ' '{printf "  %-12s: %s\n", $1, $2}'
    elif [ "$PKG_MANAGER" = "dpkg" ]; then
        # Debian-based systems (Ubuntu, Debian)
        dpkg -l git 2>/dev/null | grep "^ii" | \
            awk '{printf "  Package: %s\n  Version: %s\n  Arch: %s\n", $2, $3, $4}'
        echo "  License   : GPL v2"
        echo "  URL       : https://git-scm.com"
    else
        # Fallback: show git config info
        echo "  License   : GPL v2"
        echo "  Maintainer: Junio C Hamano and the Git community"
        echo "  URL       : https://git-scm.com"
    fi

    echo ""

    # --- Show Git's configuration details ---
    echo -e "${BOLD}${GREEN}── Git System Configuration ──────────────────────────────────${RESET}"
    echo -e "  Global config  : ${CYAN}$(git config --system --list 2>/dev/null | head -3 || echo 'N/A')${RESET}"
    echo -e "  Default branch : ${CYAN}$(git config --system init.defaultBranch 2>/dev/null || echo 'master')${RESET}"

else
    echo -e "  Status    : ${RED}✘ NOT INSTALLED${RESET}"
    echo ""

    # --- Suggest installation command ---
    echo -e "${BOLD}${YELLOW}── Install Instructions ──────────────────────────────────────${RESET}"
    if [ "$PKG_MANAGER" = "rpm" ]; then
        echo "  sudo dnf install git     # Fedora/RHEL"
        echo "  sudo yum install git     # CentOS/older RHEL"
    elif [ "$PKG_MANAGER" = "dpkg" ]; then
        echo "  sudo apt install git     # Ubuntu/Debian"
    else
        echo "  Please install git using your system's package manager."
    fi
fi

echo ""

# --- Case statement: Philosophy notes for popular FOSS packages ---
# This demonstrates the case construct in bash
echo -e "${BOLD}${GREEN}── FOSS Philosophy Notes ─────────────────────────────────────${RESET}"
echo -e "  ${YELLOW}Package Philosophy Index:${RESET}"
echo ""

# Loop through a list of packages and print their philosophy
# The case statement matches each package name and prints a relevant note
for PKG in git httpd mysql firefox vlc python3; do
    case $PKG in
        git)
            NOTE="Born from necessity — Linus built it in 10 days when BitKeeper abandoned the kernel team."
            ;;
        httpd|apache2)
            NOTE="Apache: the web server that built the open internet — powers millions of sites for free."
            ;;
        mysql)
            NOTE="MySQL: dual-licensed to show that open source and commercial can coexist — barely."
            ;;
        firefox)
            NOTE="Firefox: a nonprofit's fight to keep the web open against browser monopolies."
            ;;
        vlc)
            NOTE="VLC: built by French students who just wanted to stream video in their dorm. Now universal."
            ;;
        python3|python)
            NOTE="Python: governed entirely by community consensus — Guido van Rossum's gift to the world."
            ;;
        *)
            NOTE="An open-source tool contributing to the commons of human knowledge."
            ;;
    esac
    echo -e "  ${CYAN}$PKG${RESET}: $NOTE"
done

echo ""
echo -e "${BOLD}${CYAN}══════════════════════════════════════════════════════════════${RESET}"
echo -e "  \"Given enough eyeballs, all bugs are shallow.\""
echo -e "                                      — Eric S. Raymond"
echo -e "${BOLD}${CYAN}══════════════════════════════════════════════════════════════${RESET}"
