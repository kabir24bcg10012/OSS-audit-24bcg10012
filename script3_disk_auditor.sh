#!/bin/bash
# =============================================================================
# Script 3: Disk and Permission Auditor
# Author: Kabir | Course: Open Source Software | VIT Bhopal University
# Description: Loops through important system directories and reports their
#              size, ownership, and permissions. Also checks Git's specific
#              config directories for security-relevant information.
# =============================================================================

# --- Color codes ---
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
BOLD='\033[1m'
RESET='\033[0m'

# --- List of important system directories to audit ---
DIRS=("/etc" "/var/log" "/home" "/usr/bin" "/tmp" "/usr/share" "/var/lib")

# --- Git-specific directories to check ---
GIT_DIRS=("/etc/gitconfig" "/usr/share/git-core" "/usr/lib/git-core")

# --- Print header ---
echo -e "${BOLD}${CYAN}"
echo "╔══════════════════════════════════════════════════════════════╗"
echo "║             DISK AND PERMISSION AUDITOR                     ║"
echo "╚══════════════════════════════════════════════════════════════╝"
echo -e "${RESET}"

# --- Section 1: System Directory Audit ---
# Using a for loop to iterate over all directories in the array
echo -e "${BOLD}${GREEN}── System Directory Audit ────────────────────────────────────${RESET}"
printf "  ${BOLD}%-20s %-12s %-10s %-10s %-12s${RESET}\n" "Directory" "Permissions" "Owner" "Group" "Size"
echo "  ──────────────────────────────────────────────────────────"

for DIR in "${DIRS[@]}"; do
    # Check if directory exists before trying to inspect it
    if [ -d "$DIR" ]; then
        # Extract permissions, owner, and group using ls and awk
        PERMS=$(ls -ld "$DIR" | awk '{print $1}')
        OWNER=$(ls -ld "$DIR" | awk '{print $3}')
        GROUP=$(ls -ld "$DIR" | awk '{print $4}')

        # Get disk usage; suppress permission-denied errors with 2>/dev/null
        SIZE=$(du -sh "$DIR" 2>/dev/null | cut -f1)

        # Color-code based on permissions (world-writable is a security risk)
        if echo "$PERMS" | grep -q "w......w."; then
            # World-writable — flag it in yellow
            echo -e "  ${YELLOW}$(printf "%-20s %-12s %-10s %-10s %-12s" "$DIR" "$PERMS" "$OWNER" "$GROUP" "$SIZE")${RESET}"
        else
            echo -e "  $(printf "%-20s ${CYAN}%-12s${RESET} %-10s %-10s %-12s" "$DIR" "$PERMS" "$OWNER" "$GROUP" "$SIZE")"
        fi
    else
        # Directory does not exist on this system
        echo -e "  ${RED}$(printf "%-20s" "$DIR")${RESET}  ${RED}[Does not exist on this system]${RESET}"
    fi
done

echo ""

# --- Section 2: Overall Disk Usage Summary ---
echo -e "${BOLD}${GREEN}── Disk Usage Summary ────────────────────────────────────────${RESET}"

# df shows disk free space for mounted filesystems
# We filter for real filesystems (not tmpfs/devtmpfs)
df -h --output=source,fstype,size,used,avail,pcent,target 2>/dev/null | \
    grep -v "^tmpfs\|^devtmpfs\|^udev\|^Filesystem" | \
    while IFS= read -r LINE; do
        echo -e "  ${CYAN}$LINE${RESET}"
    done

echo ""

# --- Section 3: Git-specific Directory Audit ---
# Checking the directories where Git stores its system-level config
echo -e "${BOLD}${GREEN}── Git (Chosen Software) Directory Audit ─────────────────────${RESET}"

for GDIR in "${GIT_DIRS[@]}"; do
    if [ -e "$GDIR" ]; then
        # -e checks for existence of both files and directories
        PERMS=$(ls -ld "$GDIR" | awk '{print $1}')
        OWNER=$(ls -ld "$GDIR" | awk '{print $3}')
        SIZE=$(du -sh "$GDIR" 2>/dev/null | cut -f1)
        echo -e "  ${GREEN}✔${RESET} ${CYAN}$GDIR${RESET}"
        echo -e "      Permissions : $PERMS | Owner : $OWNER | Size : $SIZE"
    else
        echo -e "  ${YELLOW}⚠${RESET}  $GDIR ${YELLOW}[not found — may vary by distro]${RESET}"
    fi
done

echo ""

# --- Section 4: Check if any SUID/SGID binaries exist in /usr/bin (security audit) ---
echo -e "${BOLD}${GREEN}── SUID/SGID Binary Check in /usr/bin ────────────────────────${RESET}"
echo -e "  ${YELLOW}(SUID binaries run with owner privileges — a security consideration)${RESET}"

# find with -perm /6000 finds files with SUID or SGID bit set
SUID_FILES=$(find /usr/bin -perm /6000 2>/dev/null)

if [ -n "$SUID_FILES" ]; then
    echo "$SUID_FILES" | while IFS= read -r FILE; do
        PERMS=$(ls -l "$FILE" | awk '{print $1}')
        echo -e "  ${RED}⚑${RESET}  $FILE ${YELLOW}[$PERMS]${RESET}"
    done
else
    echo -e "  ${GREEN}✔ No SUID/SGID binaries found in /usr/bin${RESET}"
fi

echo ""
echo -e "${BOLD}${CYAN}══════════════════════════════════════════════════════════════${RESET}"
echo -e "  \"Transparency in permissions is the first step to security.\""
echo -e "${BOLD}${CYAN}══════════════════════════════════════════════════════════════${RESET}"
