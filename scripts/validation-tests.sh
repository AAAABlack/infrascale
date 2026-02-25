
#!/bin/bash
# validation-tests.sh - Comprehensive infrastructure testing for Infranet Lab

echo "=== DNS Forward Resolution Tests ==="
dig +short netrunner1.infranet.netkey @10.0.2.5
dig +short netrunner2.infranet.netkey @10.0.2.5
echo ""

echo "=== DNS Reverse Resolution Tests ==="
dig +short -x 10.0.2.5 @10.0.2.5
dig +short -x 10.0.2.15 @10.0.2.5
echo ""

echo "=== LDAP User Lookup Tests ==="
getent passwd john
getent passwd jane
getent passwd mark
getent passwd lucy
getent passwd ana
echo ""

echo "=== LDAP Group Lookup Tests ==="
getent group sysadmin
echo ""

echo "=== Cross-Node SSH Test ==="
echo "Testing SSH to netrunner1 using LDAP credentials..."
ssh -o ConnectTimeout=5 john@netrunner1.infranet.netkey "hostname && whoami" || echo "SSH test failed"
echo ""

echo "=== Service Status ==="
systemctl is-active bind9
systemctl is-active slapd
echo ""

echo "All tests completed!"
