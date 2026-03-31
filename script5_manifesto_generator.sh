#!/bin/bash
# =============================================================================
# Script 5: Open Source Manifesto Generator
# Author: Kabir | Course: Open Source Software | VIT Bhopal University
# Description: An interactive script that asks the user three philosophical
#              questions and generates a personalised open source manifesto,
#              saving it to a timestamped .txt file.
# Concepts: read, string concatenation, file I/O, date, aliases, functions
# =============================================================================

# --- Color codes ---
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
MAGENTA='\033[0;35m'
BOLD='\033[1m'
RESET='\033[0m'

# --- Alias demonstration ---
# Note: aliases in scripts are not inherited by child processes,
# but we can demonstrate the concept using functions (the shell equivalent)
# In interactive shells, you'd write: alias today='date +%d\ %B\ %Y'
greet_user() {
    # This function acts like an alias for a formatted greeting
    echo -e "${BOLD}${CYAN}Welcome, $1!${RESET}"
}

print_divider() {
    # Reusable divider function — avoids repeating echo statements
    echo -e "${BOLD}${CYAN}══════════════════════════════════════════════════════════════${RESET}"
}

# --- Print header ---
clear
print_divider
echo -e "${BOLD}${MAGENTA}          THE OPEN SOURCE MANIFESTO GENERATOR              ${RESET}"
print_divider
echo ""
echo -e "  This script will create a personal open source manifesto"
echo -e "  based on your answers to three questions. Take your time."
echo ""

# --- Get the current user's name for greeting ---
CURRENT_USER=$(whoami)
greet_user "$CURRENT_USER"
echo ""

# --- Interactive questions using 'read' ---
echo -e "${BOLD}${GREEN}── Question 1 ────────────────────────────────────────────────${RESET}"
echo -e "  ${YELLOW}Name one open-source tool you use every single day:${RESET}"
read -p "  > " TOOL

# Validate input — don't accept empty answers
while [ -z "$TOOL" ]; do
    echo -e "  ${RED}Please enter a tool name. It can't be empty.${RESET}"
    read -p "  > " TOOL
done

echo ""
echo -e "${BOLD}${GREEN}── Question 2 ────────────────────────────────────────────────${RESET}"
echo -e "  ${YELLOW}In one word, what does 'freedom' mean to you in the context of software?${RESET}"
read -p "  > " FREEDOM

while [ -z "$FREEDOM" ]; do
    echo -e "  ${RED}Please enter one word.${RESET}"
    read -p "  > " FREEDOM
done

echo ""
echo -e "${BOLD}${GREEN}── Question 3 ────────────────────────────────────────────────${RESET}"
echo -e "  ${YELLOW}Name one thing you would build and share with the world for free:${RESET}"
read -p "  > " BUILD

while [ -z "$BUILD" ]; do
    echo -e "  ${RED}Please enter something you'd build.${RESET}"
    read -p "  > " BUILD
done

echo ""
echo -e "${BOLD}${GREEN}── Question 4 (Bonus) ────────────────────────────────────────${RESET}"
echo -e "  ${YELLOW}Which open source license would you release your work under? (e.g. MIT, GPL, Apache):${RESET}"
read -p "  > " LICENSE_CHOICE

# Default license if left blank
LICENSE_CHOICE="${LICENSE_CHOICE:-MIT}"

# --- Generate date and output filename ---
DATE=$(date '+%d %B %Y')                         # Human-readable date
TIMESTAMP=$(date '+%Y%m%d_%H%M%S')              # Timestamp for filename
OUTPUT="manifesto_${CURRENT_USER}_${TIMESTAMP}.txt"

# --- Compose the manifesto using string concatenation ---
# Building the full text as a variable before writing
MANIFESTO_TITLE="The Open Source Manifesto of $CURRENT_USER"

MANIFESTO_BODY="Every day, I build on the work of those who came before me.
The tool I reach for most — $TOOL — exists because someone decided
that knowledge should not be locked away behind a paywall or a
corporate wall. They chose to share, and the world is better for it.

To me, freedom in software means $FREEDOM. Not just the absence of cost,
but the presence of trust — the trust that I can look at what I am running,
understand it, and change it if I need to. That trust is the foundation
of everything I do as a technologist.

One day, I will build $BUILD — and when I do, I will release it under
the $LICENSE_CHOICE license, because I believe that what I create should
add to the commons, not subtract from it.

This is not just a technical belief. It is a moral one. The open source
movement is the closest thing the technology world has to a genuine
commitment to the public good. I choose to be part of that.

I stand on the shoulders of giants — the contributors, maintainers,
and idealists who gave their time so that strangers could benefit.
I commit to carrying that forward."

MANIFESTO_FOOTER="— $CURRENT_USER | Generated on $DATE"

# --- Write manifesto to file using >> (append) and > (overwrite) ---
# Using > to create/overwrite the file with the header
echo "════════════════════════════════════════════════════" > "$OUTPUT"
echo "  $MANIFESTO_TITLE"                                  >> "$OUTPUT"
echo "════════════════════════════════════════════════════" >> "$OUTPUT"
echo ""                                                     >> "$OUTPUT"
echo "$MANIFESTO_BODY"                                      >> "$OUTPUT"
echo ""                                                     >> "$OUTPUT"
echo "$MANIFESTO_FOOTER"                                    >> "$OUTPUT"
echo "════════════════════════════════════════════════════" >> "$OUTPUT"

# --- Confirm save and display the manifesto ---
echo ""
print_divider
echo -e "${BOLD}${GREEN}  ✔ Your manifesto has been saved to: ${CYAN}$OUTPUT${RESET}"
print_divider
echo ""

# Display using cat
cat "$OUTPUT"

echo ""
print_divider
echo -e "  ${MAGENTA}\"The strength of open source is that you don't need"
echo -e "   anyone's permission to make something great.\"${RESET}"
print_divider
