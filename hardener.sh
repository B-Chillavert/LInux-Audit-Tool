#!/bin/bash

# ==========================================
# Automated Linux System Audit & Hardening Tool
# Created for Security Portfolio & Hardening
# ==========================================

echo "=========================================="
echo "Starting Linux Security Audit Script..."
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

echo "=========================================="
echo "Phase 1 Audit Complete."
echo "=========================================="
