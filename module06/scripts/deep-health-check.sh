#!/usr/bin/env bash
# ============================================================
# deep-health-check.sh — Multi-layer health verification
# Exit 0 = healthy, Exit 1 = unhealthy
# ============================================================

set -eu

APP_URL="http://localhost:8082/health"
MIN_DISK_KB=512000  # 500 MB minimum free space
LOG_FILE="/var/log/health-check.log"
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')

# --- CHECK 1: HTTP Response ---
# curl -sf fails silently on HTTP errors; --max-time sets a 5-second deadline.
HTTP_STATUS=$(curl -sf -o /dev/null -w "%{http_code}" --max-time 5 "$APP_URL" 2>/dev/null || echo "000")

if [ "$HTTP_STATUS" != "200" ]; then
    echo "$TIMESTAMP FAIL: HTTP $HTTP_STATUS" >> "$LOG_FILE"
    exit 1
fi

# --- CHECK 2: Disk Space ---
# df / reports filesystem stats; awk extracts available KB from second row.
AVAILABLE_KB=$(df / | awk 'NR==2 {print $4}')

if [ "$AVAILABLE_KB" -lt "$MIN_DISK_KB" ]; then
    echo "$TIMESTAMP FAIL: Disk low (${AVAILABLE_KB}KB)" >> "$LOG_FILE"
    exit 1
fi

# --- CHECK 3: Container Running ---
# Check if Docker container "my-web-app" is running.
if ! docker ps --filter "name=my-web-app" --filter "status=running" -q | grep -q .; then
    echo "$TIMESTAMP FAIL: Container not running" >> "$LOG_FILE"
    exit 1
fi

echo "$TIMESTAMP OK: All checks passed" >> "$LOG_FILE"
exit 0
