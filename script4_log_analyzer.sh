#!/bin/bash
# =============================================================================
# Script 4: Log File Analyzer
# Author: Kabir | Course: Open Source Software | VIT Bhopal University
# Description: Reads a log file line by line, counts keyword occurrences,
#              shows matching lines, and generates a summary report.
#              Includes retry logic if file is empty and accepts CLI arguments.
# Usage: ./script4_log_analyzer.sh [logfile] [keyword]
#        Example: ./script4_log_analyzer.sh /var/log/syslog error
# =============================================================================

# --- Color codes ---
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
BOLD='\033[1m'
RESET='\033[0m'

# --- Accept command-line arguments ---
# $1 = log file path, $2 = keyword to search (default: 'error')
LOGFILE="${1:-/var/log/syslog}"
KEYWORD="${2:-error}"

# --- Counter variables ---
TOTAL_LINES=0        # Total lines in the file
MATCH_COUNT=0        # Lines matching the keyword
WARNING_COUNT=0      # Lines containing 'warning' (bonus metric)
MAX_DISPLAY=10       # Maximum matching lines to display

# --- Print header ---
echo -e "${BOLD}${CYAN}"
echo "╔══════════════════════════════════════════════════════════════╗"
echo "║                  LOG FILE ANALYZER                          ║"
echo "╚══════════════════════════════════════════════════════════════╝"
echo -e "${RESET}"

echo -e "  Target File : ${CYAN}$LOGFILE${RESET}"
echo -e "  Keyword     : ${CYAN}$KEYWORD${RESET}"
echo ""

# --- Validate the file ---
# Check if file exists at all
if [ ! -e "$LOGFILE" ]; then
    echo -e "  ${RED}✘ Error: File '$LOGFILE' not found.${RESET}"
    echo ""

    # --- Retry logic: look for alternative log files ---
    # This simulates a do-while style retry in bash
    echo -e "  ${YELLOW}⟳ Searching for alternative log files...${RESET}"

    RETRY=0
    MAX_RETRIES=3
    FOUND=0

    # Possible fallback log files to try
    FALLBACKS=("/var/log/messages" "/var/log/kern.log" "/var/log/auth.log" "/var/log/dmesg")

    until [ $RETRY -ge $MAX_RETRIES ] || [ $FOUND -eq 1 ]; do
        for FB in "${FALLBACKS[@]}"; do
            if [ -f "$FB" ] && [ -s "$FB" ]; then
                echo -e "  ${GREEN}✔ Found fallback: $FB — using this instead.${RESET}"
                LOGFILE="$FB"
                FOUND=1
                break
            fi
        done
        RETRY=$((RETRY + 1))
        if [ $FOUND -eq 0 ] && [ $RETRY -lt $MAX_RETRIES ]; then
            echo -e "  ${YELLOW}  Attempt $RETRY/$MAX_RETRIES — no suitable log found yet.${RESET}"
        fi
    done

    if [ $FOUND -eq 0 ]; then
        echo -e "  ${RED}✘ No usable log file found after $MAX_RETRIES attempts. Exiting.${RESET}"
        exit 1
    fi
fi

# --- Check if file is empty ---
if [ ! -s "$LOGFILE" ]; then
    echo -e "  ${YELLOW}⚠ Warning: File '$LOGFILE' exists but is empty.${RESET}"
    exit 0
fi

# --- Check read permission ---
if [ ! -r "$LOGFILE" ]; then
    echo -e "  ${RED}✘ Permission denied: Cannot read '$LOGFILE'. Try running with sudo.${RESET}"
    exit 1
fi

# --- Main analysis: read the file line by line using while-read loop ---
echo -e "${BOLD}${GREEN}── Scanning File ─────────────────────────────────────────────${RESET}"

# Collect matching lines into an array for later display
MATCHING_LINES=()

# IFS= prevents trimming of leading/trailing whitespace
# -r prevents backslash interpretation
while IFS= read -r LINE; do
    TOTAL_LINES=$((TOTAL_LINES + 1))

    # Case-insensitive keyword match using grep -i
    if echo "$LINE" | grep -iq "$KEYWORD"; then
        MATCH_COUNT=$((MATCH_COUNT + 1))
        # Store the line for display (up to MAX_DISPLAY)
        if [ ${#MATCHING_LINES[@]} -lt $MAX_DISPLAY ]; then
            MATCHING_LINES+=("$LINE")
        fi
    fi

    # Also count warnings separately for the summary
    if echo "$LINE" | grep -iq "warning"; then
        WARNING_COUNT=$((WARNING_COUNT + 1))
    fi

done < "$LOGFILE"

echo -e "  ${GREEN}✔ Scan complete.${RESET}"
echo ""

# --- Display matching lines ---
echo -e "${BOLD}${GREEN}── Sample Matches (up to $MAX_DISPLAY) ───────────────────────────────${RESET}"

if [ ${#MATCHING_LINES[@]} -eq 0 ]; then
    echo -e "  ${YELLOW}No lines matching '$KEYWORD' found.${RESET}"
else
    for i in "${!MATCHING_LINES[@]}"; do
        # Truncate long lines to 100 characters for readability
        DISPLAY_LINE="${MATCHING_LINES[$i]:0:100}"
        echo -e "  ${CYAN}[$((i+1))]${RESET} $DISPLAY_LINE"
    done
fi

echo ""

# --- Print last 5 matching lines using tail + grep ---
echo -e "${BOLD}${GREEN}── Last 5 Matching Lines (grep + tail) ───────────────────────${RESET}"
LAST_MATCHES=$(grep -i "$KEYWORD" "$LOGFILE" | tail -5)
if [ -n "$LAST_MATCHES" ]; then
    echo "$LAST_MATCHES" | while IFS= read -r LLINE; do
        echo -e "  ${YELLOW}▸${RESET} ${LLINE:0:100}"
    done
else
    echo -e "  ${YELLOW}None found.${RESET}"
fi

echo ""

# --- Summary Report ---
echo -e "${BOLD}${GREEN}── Summary Report ────────────────────────────────────────────${RESET}"
echo -e "  File analyzed   : ${CYAN}$LOGFILE${RESET}"
echo -e "  Total lines     : ${CYAN}$TOTAL_LINES${RESET}"
echo -e "  Keyword         : ${CYAN}'$KEYWORD'${RESET}"
echo -e "  Matches found   : ${RED}$MATCH_COUNT${RESET}"
echo -e "  Warnings found  : ${YELLOW}$WARNING_COUNT${RESET}"

# --- Calculate match percentage ---
if [ $TOTAL_LINES -gt 0 ]; then
    # Bash does integer arithmetic only, so multiply first
    PERCENT=$(( (MATCH_COUNT * 100) / TOTAL_LINES ))
    echo -e "  Match rate      : ${CYAN}$PERCENT%${RESET}"
fi

echo ""
echo -e "${BOLD}${CYAN}══════════════════════════════════════════════════════════════${RESET}"
echo -e "  \"Logs are the memory of the system — read them like history.\""
echo -e "${BOLD}${CYAN}══════════════════════════════════════════════════════════════${RESET}"
