
## Architecture Overview

        ┌──────────────────────────────┐
        │        Client (Browser)      │
        └──────────────┬───────────────┘
                       │
                8080 (HTTP)
                       │
              ┌────────▼────────┐
              │      Nginx      │
              │ Reverse Proxy   │
              └────────┬────────┘
                       │
              ┌────────▼────────┐
              │     Webapp      │
              │ Flask/Gunicorn  │
              └────────┬────────┘
                       │
              ┌────────▼────────┐
              │      Redis      │
              │     (Cache)     │
              └─────────────────┘

    ┌──────────────────────────────┐
    │   Private Registry (5000)    │
    └──────────────────────────────┘

a 3 container setup where Nginx is the entry point, forwarding requests to the web application, which communicates with Redis for caching. A private registry is used to store and distribute images across nodes.

---

## Tool Choices

- Docker: Chosen for its industry adoption, ecosystem, and strong support for multi-container environments via Docker Compose.  
- Nginx: Used as a reverse proxy for routing traffic and separating frontend access from backend services.  

---

## Network Topology

- Primary Node: `10.0.2.5`  
- Secondary Node: `10.0.2.15`  

**Ports:**
- `8080 → Nginx (public access)`
- `5000 → Private registry`

**DNS:**
- `dashboard.infranet.netkey → 10.0.2.5`
- `registry.infranet.netkey → 10.0.2.5`

**Internal Network:**
- Docker bridge network (`infrascale-net`)
- Services communicate via container names (e.g., `webapp`, `redis`)

---

## Lessons Learned

- Small configuration errors (especially in DNS) can break entire systems and are hard to debug.  
- Docker networking simplifies service communication but requires understanding of port mapping and isolation.  
- Dependency on correct DNS and networking inside containers is critical during builds.  

---

## Security Considerations

- Use HTTPS (TLS) instead of HTTP for all services.  
- Secure the private registry with authentication.  
- Scan images for vulnerabilities before deployment.  
- Avoid running containers as root and limit exposed ports.  
