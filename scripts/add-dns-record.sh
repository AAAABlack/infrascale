#!/bin/bash
# add-dns-record.sh - Add A and PTR records to DNS
# Usage: ./add-dns-record.sh <hostname> <ip>

if [ $# -lt 2 ]; then
 echo "Usage: $0 <hostname> <ip>"
 exit 1
fi

HOSTNAME=$1
IP=$2

ZONE_FILE="/var/cache/bind/db.infranet.netkey"
REVERSE_FILE="/var/cache/bind/db.10.0.2"

LAST_OCTET=$(echo $IP | awk -F. '{print $4}')

# Backup zone files
sudo cp $ZONE_FILE ${ZONE_FILE}.backup
sudo cp $REVERSE_FILE ${REVERSE_FILE}.backup

# Increment serial in forward zone
CURRENT_SERIAL=$(grep -oP '(?<=; Serial$)\s*\K[0-9]+' $ZONE_FILE)
NEW_SERIAL=$((CURRENT_SERIAL + 1))

# Add A record
echo "$HOSTNAME IN A $IP" | sudo tee -a $ZONE_FILE

# Update serial
sudo sed -i "s/$CURRENT_SERIAL ; Serial/$NEW_SERIAL ; Serial/" $ZONE_FILE

# Add PTR record
echo "$LAST_OCTET IN PTR $HOSTNAME.infranet.netkey." | sudo tee -a $REVERSE_FILE

# Update serial in reverse zone
CURRENT_SERIAL_REV=$(grep -oP '(?<=; Serial$)\s*\K[0-9]+' $REVERSE_FILE)
NEW_SERIAL_REV=$((CURRENT_SERIAL_REV + 1))
sudo sed -i "s/$CURRENT_SERIAL_REV ; Serial/$NEW_SERIAL_REV ; Serial/" $REVERSE_FILE

# Reload BIND
sudo systemctl reload bind9

echo "DNS records added successfully!"
echo "Testing..."
dig +short $HOSTNAME.infranet.netkey
