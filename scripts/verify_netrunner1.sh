#!/bin/bash
# InfraScale Module 1 Verification Script
# Author: Adem
# Date: 10-2-2026

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
PEER_HOST="netrunner2" # Default peer
if [ "$(hostname)" == "netrunner2" ]; then
  PEER_HOST="netrunner1"
fi

PEER_HOSTNAME=$(ssh -o BatchMode=yes -o ConnectTimeout=5 "$PEER_HOST" \
'hostname' 2>/dev/null)

if [ -n "$PEER_HOSTNAME" ]; then
  echo "[CHECK 3] Passwordless SSH to $PEER_HOST: SUCCESS ($PEER_HOSTNAME)"
else
  echo "[CHECK 3] Passwordless SSH to $PEER_HOST: FAILED" && exit 1
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
