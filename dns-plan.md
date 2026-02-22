# Choosing domain name:

- The domain/zone name will be infranet.netkey. example: netrunner1.infranet.netkey

- It goes without saying that this a private domain and not accessible by anyone outside of this private infrascale.

# IP Address Scheme: 

- IP range; 10.0.2.0/24

- Static IP & naming:

netrunner1.infranet.netkey (hostname) - 10.0.2.5 (IP)
netrunner2.infranet.netkey (hostname) - 10.0.2.15 (IP)

# Zone File Design:

- Forward Zone name: infranet.netkey
- IP network: 10.0.2.0/24
- Reverse Zone name (PTR): 2.0.10.in-addr.arpa (octets reversed) <- learned new!
 
# A records

hostname	FQDN				IP Address 
---------------------------------------------------------------
- netrunner1	netrunner1.infranet.netkey	10.0.2.5
- netrunner2	netrunner2.infranet.netkey	10.0.2.15

# PTR Records

IP Address	PTR Record
---------------------------------------------------------------
- 10.0.2.5 	netrunner1.infranet.netkey
- 10.0.2.15	netrunner2.infranet.netkey

# CNAME Records

Alias			Points to			Purpose			
---------------------------------------------------------------
- dns.infranet.netkey	netrunner1.infranet.netkey	DNS alias
- ldap.infranet.netkey	netrunner1.infranet.netkey	LDAP alias		
- ns1.infranet.netkey 	netrunner1.infranet.netkey	ns1 (like google)
