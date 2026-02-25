#!/bin/bash
# create-ldap-user.sh
# Creates a new LDAP user with an INTERACTIVE password prompt
# Usage: ./create-ldap-user.sh <username> <firstname> <lastname>

set -e

DOMAIN="dc=infranet,dc=netkey"
PEOPLE_OU="ou=People,$DOMAIN"
ADMIN_DN="cn=admin,$DOMAIN"

if [ $# -lt 3 ]; then
    echo "Usage: $0 <username> <firstname> <lastname>"
    exit 1
fi

USERNAME="$1"
FIRSTNAME="$2"
LASTNAME="$3"

# Here we input the password directly for the user
while true; do
    read -s -p "Enter password for $USERNAME: " PASSWORD
    echo
    read -s -p "Confirm password: " PASSWORD_CONFIRM
    echo

    if [ "$PASSWORD" = "$PASSWORD_CONFIRM" ]; then
        break
    else
        echo "Passwords do not match. Try again."
    fi
done

# we give the next available UID!! 
LAST_UID=$(ldapsearch -x -LLL -b "$PEOPLE_OU" "(objectClass=posixAccount)" uidNumber \
    | awk '/uidNumber/ {print $2}' | sort -n | tail -1)

if [ -z "$LAST_UID" ]; then
    NEXT_UID=10010
else
    NEXT_UID=$((LAST_UID + 1))
fi

# Hashing password earlier inputted
HASH=$(slappasswd -s "$PASSWORD")

TMP_LDIF="/tmp/${USERNAME}.ldif"

# Creating LDIF while specifying a few other stuff like the default users given to us in the report 
cat > "$TMP_LDIF" <<EOF
dn: uid=$USERNAME,$PEOPLE_OU
objectClass: inetOrgPerson
objectClass: posixAccount
objectClass: shadowAccount
cn: $FIRSTNAME $LASTNAME
sn: $LASTNAME
uid: $USERNAME
uidNumber: $NEXT_UID
gidNumber: 10001
homeDirectory: /home/$USERNAME
loginShell: /bin/bash
userPassword: $HASH
mail: $USERNAME@infranet.netkey
description: Auto-created user
EOF

# Finally, adding the user
ldapadd -x -D "$ADMIN_DN" -W -f "$TMP_LDIF"

rm "$TMP_LDIF"

echo "--------------------------------------"
echo "User created successfully"
echo "Username: $USERNAME"
echo "UID: $NEXT_UID"
echo "Password set manually"
echo "--------------------------------------"
