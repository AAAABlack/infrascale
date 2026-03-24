#!/usr/bin/env bash

# Simulated log aggregation service.
# Students: replace with Loki, Fluentd, Filebeat, or build your own!

echo "InfraScale Log Aggregator starting up"

while true; do
    echo "[$(date -u +%Y-%m-%dT%H:%M:%SZ)] Aggregator heartbeat — $(hostname)"
    sleep 15
done
