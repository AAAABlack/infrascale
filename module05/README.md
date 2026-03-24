 # Module 05 Reflection

## Overview

This lab was about stopping manual work and letting the system handle itself as written. Instead of running scripts manually, everything is handled through systemd, timers, and cron. So services start automatically, restart if they crash, and logs are tracked properly.

---

## What Worked

- The healthcheck service worked after testing it manually first, then putting it into systemd.
- Had to change the port from 8080  8081 because Docker was already using 8080.
- The log aggregation service worked and correctly depended on the health service.
- Restart policies behaved exactly as expected — killing the service brought it back, and eventually it hit the restart limit.
- Timers worked properly and honestly felt cleaner than cron once configured.
- Verification script passed fully in the end, so everything was running as expected.

---

## What Didn’t Work (at first)

A few things broke along the way:

- Got a `226/NAMESPACE` error on the health service
  - Turned out the logs directory didn’t exist
  - systemd basically refused to start because of that
  - fixed it by creating `/opt/infrascale/logs` and setting perms

- Cron jobs wouldn’t save at first
  - formatting issue, commands were split across lines
  - cron is strict, everything has to be on one line

- Some small mistakes:
  - wrong service names (missing dashes)
  - wrong port (forgot to switch to 8081 in some places)

---

## Key Takeaways

- Always test scripts manually before touching systemd
- Don’t guess when something breaks use `journalctl`
- systemd is strict with configs, paths, and permissions
- Small mistakes can completely stop services from running
- Once everything is set up properly, the system basically manages itself

---

## Reflection

Stuff actually broke, and I had to figure out why instead of just following steps. The biggest thing was learning to check logs instead of guessing that made everything easier.

Also, once you understand how systemd works, it starts to make sense why everything is structured the way it is. Breaking the service on purpose and watching it restart was actually useful, not just filler.

Overall, this felt closer to real-world stuff compared to earlier labs.
This paste expires in <1 hour. Public IP access. Share whatever you see with others in seconds with Context. Terms of ServiceReport this
