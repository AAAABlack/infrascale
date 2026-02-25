
# Infrastructure

## Overview

The infrastructure provides:

- Authoritative DNS with BIND9
- Centralized authentication using OpenLDAP
- Linux authentication integration using NSS (not needed if windows was used) and PAM
- Cross-node login using LDAP credentials
- Automated DNS and LDAP management via scripts

-----------------------------------------------------------------------------

## Network Architecture

 Role | Hostname | FQDN | IP Address |
------|----------|------|------------|
 DNS + LDAP Server | netrunner1 | netrunner1.infranet.netkey | 10.0.2.5 |
 Client Node | netrunner2 | netrunner2.infranet.netkey | 10.0.2.15 |

Network range: 10.0.2.0/24

-----------------------------------------------------------------------

## DNS Infrastructure

### DNS Software
BIND9 (Authoritative DNS Server)

### Forward Zone

- Domain: infranet.netkey  
- Zone file: /var/cache/bind/db.infranet.netkey  

#### A Records

 Hostname | IP Address |
----------|------------|
 netrunner1 | 10.0.2.5 |
 netrunner2 | 10.0.2.15 |

#### CNAME Records

 Alias | Target | Purpose |
--------|--------|---------|
 dns | netrunner1 | DNS service alias |
 ldap | netrunner1 | LDAP service alias |
 ns1 | netrunner1 | Nameserver alias |

-----------------------------------------------------------

### Reverse Zone

- Network: 10.0.2.0/24  
- Reverse Zone Name: 2.0.10.in-addr.arpa  
- Zone file: /var/cache/bind/db.10.0.2  

#### PTR Records

 IP Address | PTR Record |
------------|------------|
 10.0.2.5 | netrunner1.infranet.netkey |
 10.0.2.15 | netrunner2.infranet.netkey |

---------------------------------------------------------------

## LDAP Directory Configuration

### Base DN

dc=infranet,dc=netkey

### Organizational Units

- ou=People
- ou=Groups
- ou=System

### Users

 Username | UID | Primary Group |
----------|------|--------------|
 john | 10001 | sysadmin |
 jane | 10002 | sysadmin |
 mark | 10003 | sysadmin |

### Groups

 Group | GID | Members |
--------|------|----------|
 sysadmin | 10001 | john, jane, mark |
 developers | 10002 | none |

-----------------------------------------------------------------

## Authentication Architecture

Authentication flow: from 1 to 5, simplified

1. User attempts login
2. PAM takes care of authentication
3. NSS retrieves user data from LDAP
4. LDAP verifies password
5. Access given if credentials are valid

This happens across both nodes as of yet

----------------------------------------------------------

## Security Configuration

- Firewall allows DNS (53 TCP/UDP) and LDAP (389 TCP)
- Internal DNS server configured via systemd-resolved
- DNS recursion enabled with forwarders for public DNS resolution, explained further in report
- LDAP logging enabled for troubleshooting
- All services enabled on boot

-------------------------------------------------------------

## Automation Scripts

Location:

~/infrascale/scripts/

Scripts included:

- create-ldap-user.sh |  Automates LDAP user creation
- add-dns-record.sh |  Automates DNS A and PTR record creation

--------------------------------------------------------------

## Validation Commands

DNS Forward Lookup:

dig @10.0.2.5 netrunner1.infranet.netkey

DNS Reverse Lookup:

dig @10.0.2.5 -x 10.0.2.5

LDAP Query:

ldapsearch -x -H ldap://ldap.infranet.netkey -b "dc=infranet,dc=netkey"

User Lookup:

getent passwd john

Cross-node Authentication:

ssh john@netrunner1.infranet.netkey

------------------------------------------------------

## Result as of yet

The infrastructure does:

- Functional authoritative DNS
- Forward and reverse name resolution
- Centralized identity management
- Cross-node LDAP authentication
- Basic security hardening
- Automation of infrastructure tasks

# still a work in progress
