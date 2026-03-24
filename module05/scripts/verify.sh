
#!/usr/bin/env bash

# InfraScale Module 05 — Verification Script
# Run this on your primary node

echo "============================================"
echo " InfraScale Module 05 Verification"
echo "============================================"
echo ""

PASS=0
FAIL=0

check() {
    local desc="$1"
    local cmd="$2"

    if eval "$cmd" &>/dev/null; then
        echo " ✓ $desc"
        ((PASS++))
    else
        echo " ✗ $desc ← INVESTIGATE"
        ((FAIL++))
    fi
}

echo "--- Services ---"
check "infrascale-health is active" "systemctl is-active infrascale-health.service"
check "infrascale-logagg is active" "systemctl is-active infrascale-logagg.service"
check "infrascale-health responds" "curl -sf http://localhost:8081/health"

echo ""
echo "--- Timers ---"
check "infrascale-cleanup.timer active" "systemctl is-active infrascale-cleanup.timer"
check "infrascale-healthsnap.timer active" "systemctl is-active infrascale-healthsnap.timer"

echo ""
echo "--- Journal ---"
check "Journal has health entries" "journalctl -u infrascale-health.service -n 1 -q"
check "Journal has logagg entries" "journalctl -u infrascale-logagg.service -n 1 -q"

echo ""
echo "--- Log files ---"
check "Health snapshot log exists" "test -f /opt/infrascale/logs/health_snapshots.log"

echo ""
echo "============================================"
echo " Results: ${PASS} passed, ${FAIL} failed"
echo "============================================"
