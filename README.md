# Infrascale Project

Distributed Systems course semester Project.

## Author

- Name: Adem
- Student ID: 92610

---------------------------------------------------------

## Hosts

 Host | Role |
------|------|
netrunner1 | DNS and LDAP server |
netrunner2 | Client node |

Domain: infranet.netkey  
Network: 10.0.2.0/24

---------------------------------------------------------

## Quick Functional Test

Run these commands

### DNS resolution

dig netrunner1.infranet.netkey
dig -x 10.0.2.5


### LDAP user visibility

getent passwd john


### Cross-node authentication

ssh john@netrunner1.infranet.netkey


If these succeed, the infrastructure is working.

-------------------------------------------------------------

## Automation Scripts

Located in:

~/infrascale/scripts/


Create LDAP user:

./create-ldap-user.sh <username> <firstname> <lastname>


Add DNS record:

./add-dns-record.sh <hostname> <ip>


------------------------------------------------------------

## Documentation

Detailed technical information is in:

- dns-plan.md — DNS design
- INFRASTRUCTURE.md — full system configuration
- MODULE02-REFLECTION.md — implementation analysis


# still a work in progress
