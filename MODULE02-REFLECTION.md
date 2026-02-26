1. What challenges did you encounter?

 I faced DNS challenges. Not in the setup of BIND9 itself, but the VM network settings themselves. The UI settings tab didn’t function as desired. DNS prioritization didn’t actually seem to do anything, only public DNS servers were queried, which of course resulted in a failure. The fix was to only place the BIND9 server IP (netrunner1) on both network settings and point to forwarders in the config.

The secondary issue was the LDAP-AUTH-CONFIG, upon installing nscd, the link example is automatically started with ldapi:///, which is what you’d use if you want to connect via local IPC, Unix domain socket. So no other machine but the host machine could authenticate. So for hours I was troubleshooting why the client machine couldn’t authenticate and why the error log file kept outputting ‘couldn’t contact LDAP server - unavailable’ despite theoretically perfect settings. But the entire time, upon installation, the server it was trying to reach  was ldapi:///ldap.infranet.netkey, so it was looking within. I finally rolled back the snapshot and spotted the error immediately upon installation. The server configured is now ldap://ldap.infranet.netrunner. The remaining connectivity issues were just ufw but that was quickly fixed.


2. How did DNS and LDAP integration improve your infrastructure? 

It’s definitely more optimized in terms of workflow and DNS resolution. Especially the aliases that allowed me to resolve the sever with a couple ‘names.’ Testing is also speedy now. 

3. What alternative tools did you research? Why did you choose what you chose? 

I researched PowerDNS and Unbound as a DNS server, However, I still went with BIND9 due to available resources and easily configurable files while maintaining high flexibility. 

4. What security concerns remain in your current configuration? 

Not much concern regarding external attacks because this is a private lab, however I’m still configuring a tighter ACL. UFW is also airtight as of now. I have no tested traditional pentesting yet on the infrastructure.

5. How would you scale this to 10 or 100 nodes? 

I would switch to Vagrant in order to start up and configure many VMs at the same time. When it comes to user addition, the scripts and health checks can be automated and looped across each machine. I´m not sure how I’d go about local user accounts yet per node, AKA root access. 
