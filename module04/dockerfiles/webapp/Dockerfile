
# ── Stage 1: Base image selection ──────────────────────────────────
# Use the official Python slim image with a PINNED version.
# The 'slim' variant excludes documentation and development headers,
# reducing the image size from ~900MB to ~150MB.
# NEVER use ':latest' — it is a moving target that breaks reproducibility.
FROM python:3.12-slim AS base

# ── Metadata labels ────────────────────────────────────────────────
# Labels help identify the image in a registry and during audits.
# These follow the OCI (Open Container Initiative) annotation spec.
LABEL maintainer="aamri@schiller.students.edu"
LABEL org.opencontainers.image.title="InfraScale Dashboard"
LABEL org.opencontainers.image.description="Module 04 system status service"
LABEL org.opencontainers.image.version="1.0.0"

# ── Working directory ──────────────────────────────────────────────
# Set a clean working directory inside the container.
# All subsequent commands will execute relative to this path.
WORKDIR /app

# ── Dependency installation (cached layer) ─────────────────────────
# CRITICAL: Copy ONLY the requirements file first.
# Docker caches this layer. If requirements.txt has not changed,
# this expensive pip install step is skipped.
COPY requirements.txt .

# fixing DNS issue, docker fails to reach the local bind9 set up so will route from here
# probably a permanent fix incase a different person is running into this issue
# RUN echo "nameserver 8.8.8.8" > /etc/resolv.conf

# need to add curl here, because the webapp container kept failing due to the dependancy failing to start 
RUN apt-get update && apt-get install -y curl && rm -rf /var/lib/apt/lists*

# Install Python dependencies without caching downloaded wheel files.
RUN pip install --no-cache-dir -r requirements.txt

# ── Application code (frequently changing layer) ───────────────────
# Copy the application source code LAST because it changes most often.
COPY app.py .

# ── Port documentation ─────────────────────────────────────────────
# EXPOSE does not publish the port — it documents the internal port.
EXPOSE 5000

# ── Security: run as non-root ──────────────────────────────────────
# Create a dedicated non-root user for running the application.
RUN useradd --create-home --uid 1001 --shell /bin/bash appuser

# Switch to the non-root user
USER 1001

# ── Container startup command ──────────────────────────────────────
# Use gunicorn instead of Flask's dev server.
CMD ["gunicorn", "--workers", "2", "--bind", "0.0.0.0:5000", "app:app"]
