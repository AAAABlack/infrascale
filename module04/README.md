# InfraScale — Module 04: Containerization

## Container Engine
- Engine: Docker
- Version: 29.3.0
- Node 1 (Primary): netrunner1
- Node 2 (Secondary): netrunner2

---

## Tool Choices and Justifications

- **Docker**: Selected due to its reliability, industry-wide acceptance, and support for Docker Compose and Registry. Docker was selected over Podman due to a better user experience in orchestrating multi-container applications in this lab environment.
- **Docker Compose**: Selected to create and manage the multi-container application architecture, which consists of the webapp, nginx, and redis containers.
- **Redis**: Selected to serve as the in-memory cache to avoid repeated computations, simulating a real-world scenario in which a distributed system uses caching.
- **Nginx**: Selected to serve as the reverse proxy to forward incoming requests to the backend web application, simulating a real-world application.
- **Gunicorn**: Selected to serve as the WSGI server instead of the Flask development server, which is suitable only for production environments.

---

## Architecture Decisions

The system follows a three-tier containerized architecture:

1. **Web Application (Flask + Gunicorn)**
   - Provides `/`, `/health`, and `/status` endpoints
   - Connects to Redis for caching system status data

2. **Redis Cache**
   - Stores recently generated system status responses
   - Reduces redundant computation and improves response time

3. **Nginx Reverse Proxy**
   - Exposes the application on port `8080`
   - Routes incoming requests to the webapp container
   - Provides an additional health endpoint (`/nginx-health`)

All services are connected through an isolated Docker bridge network (`infrascale-net`), allowing communication via service names (internal DNS).

---

## Network Topology

- Internal Network: `infrascale-net` (Docker bridge)
- External Access:
  - Host Port `8080` → Nginx (Container Port `80`)
- Service Communication:
  - Nginx → Webapp (`webapp:5000`)
  - Webapp → Redis (`redis:6379`)

---

## Challenges and Solutions

The main challenge that was encountered was that DNS resolution was not working inside the Docker containers during the build process. This was solved by changing the network settings to Bridged Adapter rather than NAT. This allowed the containers to be able to access external DNS servers directly.

The second challenge that was encountered was that the web application container was not being recognized as healthy. This was solved by adding `curl` to the container. This was because `curl` was required to be installed as part of the health check command. This was solved by adding `RUN apt-get update && apt-get install curl` to the Dockerfile. This allowed the container to be recognized as healthy, which allowed other services to start successfully.

---

## Lessons Learned

- Container networking differs significantly from host networking, especially in virtualized environments.
- DNS resolution issues can appear as unrelated dependency errors during builds.
- Health checks are critical for orchestrating multi-container systems and can block dependent services if misconfigured.
- Proper debugging requires inspecting logs, container states, and network behavior rather than assuming application-level issues.

---

## Security Considerations

- Containers run as a non-root user (`appuser`) to reduce privilege escalation risks.
- Sensitive data (e.g., credentials) is not stored in the repository.
- Only necessary ports are exposed (`8080` via Nginx).
- In a production environment, improvements would include:
  - TLS/HTTPS configuration
  - Secure private registry with authentication
  - Image vulnerability scanning
  - Secrets management (e.g., environment variables or vaults)

---
