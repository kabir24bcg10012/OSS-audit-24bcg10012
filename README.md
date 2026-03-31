# oss-audit-24BCG10012

## The Open Source Audit — Git

**Student:** Kabir Verma
**Course:** Open Source Software (NGMC) | VIT Bhopal University  
**Chosen Software:** Git (Version Control System) — Licensed under GPL v2  

---

## About This Project

This repository is the capstone submission for the OSS NGMC course. It contains five shell scripts that demonstrate practical Linux and open source concepts, structured around an audit of **Git** — the distributed version control system created by Linus Torvalds in 2005.

Git was chosen because it has one of the most dramatic and philosophically rich origin stories in open source history: it was built in response to a proprietary tool being revoked from the Linux kernel team, and in doing so became the most widely used version control system on Earth.

---

## Repository Structure

```
oss-audit-[rollnumber]/
├── script1_system_identity.sh       # System identity report
├── script2_foss_inspector.sh        # FOSS package inspector
├── script3_disk_auditor.sh          # Disk and permission auditor
├── script4_log_analyzer.sh          # Log file analyzer
├── script5_manifesto_generator.sh   # Open source manifesto generator
└── README.md                        # This file
```

---

## Scripts Overview

### Script 1 — System Identity Report
Displays a formatted system identity screen showing the Linux distribution, kernel version, logged-in user, home directory, system uptime, date/time, CPU, RAM, and the OS license.

**Concepts used:** Variables, `echo`, command substitution (`$()`), conditional file reading, output formatting with ANSI colors.

### Script 2 — FOSS Package Inspector
Checks whether Git is installed on the system, displays its version and license metadata (using `rpm -qi` or `dpkg -l` depending on the distro), and uses a `case` statement to print philosophical notes about popular FOSS packages.

**Concepts used:** `if-then-else`, `case` statement, `command -v`, `rpm -qi` / `dpkg -l`, `grep`, `pipe`.

### Script 3 — Disk and Permission Auditor
Loops through a list of important system directories (`/etc`, `/var/log`, `/home`, `/usr/bin`, `/tmp`, etc.) and reports each one's permissions, owner, group, and disk usage. Also audits Git-specific config directories and flags SUID/SGID binaries.

**Concepts used:** `for` loop, arrays, `ls -ld`, `du -sh`, `awk`, `cut`, `find -perm`, color-coded output.

### Script 4 — Log File Analyzer
Reads a log file line by line and counts how many lines contain a given keyword (default: `error`). Includes retry logic if the specified file is missing, displays sample matching lines, and prints a summary report.

**Usage:**
```bash
./script4_log_analyzer.sh /var/log/syslog error
./script4_log_analyzer.sh /var/log/auth.log warning
```

**Concepts used:** `while read` loop, `if-then`, counter variables, command-line arguments (`$1`, `$2`), `until` loop for retry logic, `grep -i`, `tail`.

### Script 5 — Open Source Manifesto Generator
An interactive script that asks four questions and generates a personalised open source philosophy statement, saving it to a timestamped `.txt` file.

**Concepts used:** `read` for interactive input, input validation loops, string concatenation, writing to files with `>` and `>>`, `date` command, functions (as alias equivalents), `cat`.

---

## How to Run

### Step 1: Clone the repository
```bash
git clone https://github.com/[yourusername]/oss-audit-[rollnumber].git
cd oss-audit-24bcg10012
```

### Step 2: Make scripts executable
```bash
chmod +x script*.sh
```

### Step 3: Run each script

```bash
# Script 1 - No arguments needed
./script1_system_identity.sh

# Script 2 - No arguments needed
./script2_foss_inspector.sh

# Script 3 - No arguments needed (run as sudo for full disk info)
sudo ./script3_disk_auditor.sh

# Script 4 - Pass a log file and optional keyword
./script4_log_analyzer.sh /var/log/syslog error
# or simply:
./script4_log_analyzer.sh        # uses defaults

# Script 5 - Interactive, no arguments
./script5_manifesto_generator.sh
```

---

## Dependencies

All scripts use standard tools available on any Linux system:

| Tool | Purpose | Package |
|------|---------|---------|
| `bash` | Shell interpreter | Pre-installed |
| `git` | Chosen software | `apt install git` / `dnf install git` |
| `awk` | Text processing | Pre-installed (gawk) |
| `grep` | Pattern matching | Pre-installed |
| `df`, `du` | Disk usage | Pre-installed (coreutils) |
| `rpm` or `dpkg` | Package metadata | Distro-dependent |
| `find` | File searching | Pre-installed |

Scripts 1–3 and 5 run with no special permissions. Script 4 may need `sudo` to read protected log files. Script 3 may show incomplete disk info without `sudo`.

---

## Tested On

- Ubuntu 22.04 LTS (Jammy)
- Fedora 39
- Debian 12 (Bookworm)
- Any bash 4.0+ system

---

## License

This project (the scripts and documentation) is released under the **MIT License** — because open source should stay open.
