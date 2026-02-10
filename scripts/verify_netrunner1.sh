#!/bin/bash
# InfraScale Module 1 Verification Script
# Author: [Your Name]
# Date: [Current Date]
set -e # Exit on first error
echo "======================================"
echo "Module 1 Infrastructure Verification"
echo "======================================"
echo ""
# Check 1: Local hostname
echo "[CHECK 1] Local hostname: $(hostname)"
# Check 2: SSH key exists
if [ -f ~/.ssh/id_rsa ]; then
 echo "[CHECK 2] SSH private key: EXISTS"
else
 echo "[CHECK 2] SSH private key: MISSING" && exit 1
fi
# Check 3: Passwordless SSH to peer node
PEER_IP="192.168.56.102" # Adjust if running on node02
if [ "$(hostname)" == "node02" ]; then
 PEER_IP="192.168.56.101"
fi
PEER_HOSTNAME=$(ssh -o BatchMode=yes -o ConnectTimeout=5 vagrant@$PEER_IP
'hostname' 2>/dev/null)
if [ -n "$PEER_HOSTNAME" ]; then
 echo "[CHECK 3] Passwordless SSH to $PEER_IP: SUCCESS ($PEER_HOSTNAME)"
Distributed Systems — Module 1 Laboratory Exercises
Page 13
else
 echo "[CHECK 3] Passwordless SSH to $PEER_IP: FAILED" && exit 1
fi
# Check 4: Git repository initialized
if [ -d ~/infrascale/.git ]; then
 echo "[CHECK 4] Git repository: INITIALIZED"
 echo " Commits: $(git -C ~/infrascale log --oneline | wc -l)"
else
 echo "[CHECK 4] Git repository: NOT FOUND" && exit 1
fi
# Check 5: Project directory structure
echo "[CHECK 5] Project structure:"
ls -la ~/infrascale/
echo ""
echo "======================================"
echo "All checks PASSED successfully!"
echo "======================================"
