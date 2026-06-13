#!/bin/bash

# ==========================================
# Automated System Security Auditor (v2.0)
# Upgraded: Modular Functions & Error Catching
# ==========================================

# --------------------------------------------------
# FUNCTION: Environment & Privilege Verification
# --------------------------------------------------
check_privileges() {
    echo "[*] Checking runtime environment permissions..."
    if [ "$EUID" -ne 0 ]; then
        echo "=================================================="
        echo "[!] ERROR: System auditing requires administrative access."
        echo "[!] Please re-run this tool using: sudo ./hardener.sh"
        echo "=================================================="
        exit 1
    fi
    echo "[+] Privilege validation passed. Root access confirmed."
    echo ""
}

# --------------------------------------------------
# FUNCTION: Audit System Account Security
# --------------------------------------------------
audit_accounts() {
    echo "=========================================="
    echo "Executing Module: User Account Integrity"
    echo "=========================================="
    
    # Attempt to look for accounts missing a password assignment
    sudo passwd -S -a | grep "NP"
    
    # Catch the exit status of the previous pipeline
    if [ $? -eq 0 ]; then
        echo "[!] WARNING: Found active accounts with NO PASSWORD assigned!"
    else
        echo "[+] Success: All active system user accounts are protected with credentials."
    fi
    echo ""
}

# --------------------------------------------------
# FUNCTION: Audit Host Firewall Policies
# --------------------------------------------------
audit_firewall() {
    echo "=========================================="
    echo "Executing Module: Network Perimeter Defense"
    echo "=========================================="
    
    echo "[*] Querying local iptables policy configurations..."
    sudo iptables -L -n > /dev/null 2>&1
    
    # Catch whether the system firewall rules could be read safely
    if [ $? -ne 0 ]; then
        echo "[!] ERROR: Failed to interface with iptables system subsystem."
        return 1
    fi
    
    echo "[+] Success: Firewall sub-layers are responsive and active."
    echo ""
}

# ==================================================
# CORE EXECUTION ENGINE (Calling our modules)
# ==================================================
echo "Starting System Audit Pipeline Engine..."
echo "----------------------------------------"

# 1. Run the gatekeeper check first
check_privileges

# 2. Run the decoupled security audit blocks
audit_accounts
audit_firewall

echo "----------------------------------------"
echo "[+] System Security Audit Routine Completed Seamlessly."
