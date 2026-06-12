#!/bin/bash
# --------------------------------------------------
# CRITICAL PRIVILEGE CHECK: Ensure script is run as root
# --------------------------------------------------
if [ "$EUID" -ne 0 ]; then
    echo "=================================================="
    echo "[!] ERROR: System auditing requires administrative access."
    echo "[!] Please re-run this tool using: sudo ./hardener.sh"
    echo "=================================================="
    exit 1
fi

# ==========================================
# Automated Linux System Audit & Hardening Tool
# Version 2.0 - Extended Hardening Modules
# ==========================================

echo "=========================================="
echo "Starting Linux Security Audit Script v2.0..."
echo "=========================================="
echo ""

# Check 1: Identify the current user executing the script
echo "[*] Checking current privileges..."
echo "Running as user: $USER"
echo ""

# Check 2: List currently active logged-in users
echo "[*] Checking active logged-in sessions..."
w
echo ""

# Check 3: Check for user accounts with administrative (UID 0) access
echo "[*] Scanning for root-privileged accounts..."
echo "Accounts with UID 0 (Root access):"
awk -F: '($3 == 0) {print $1}' /etc/passwd
echo ""

# Check 4: Audit critical areas for insecure permissions (World-Writable Files)
echo "[*] Auditing system for world-writable configuration files..."
echo "Searching /etc directory for globally editable files..."
# This finds files in /etc that have the 'other-writable' (o+w) bit enabled
find /etc -type f -perm -o+w 2>/dev/null
echo "[+] Audit of /etc file permissions complete."
echo ""

# Check 5: Check network perimeter defense (Firewall verification)
echo "[*] Verifying Uncomplicated Firewall (UFW) operational status..."
if command -v ufw >/dev/null 2>&1; then
    # ufw status requires administrative elevation; if standard user, it notes restriction
    sudo ufw status 2>/dev/null || echo "[-] Unable to read firewall state. Execute script with sudo for deep firewall parsing."
else
    echo "[!] CRITICAL ALERT: UFW package utility is not installed on this system."
fi
echo ""

echo "=========================================="
echo "Phase 2 Security Audit and Hardening Scan Complete."
echo "=========================================="
