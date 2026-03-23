"""
InfraScale Module 04 — System Status Dashboard
A lightweight web service that returns node health information.
Connects to Redis for caching to demonstrate multi-container communication.
"""

# Import the Flask micro-framework for handling HTTP requests
from flask import Flask, jsonify

# Import the redis client library for connecting to the Redis cache container
import redis

# Import standard library modules for gathering system information
import platform
import datetime
import os
import socket

# Create the Flask application instance
app = Flask(__name__)

# Connect to Redis using the hostname 'redis' which will be resolved
# by Docker Compose's internal DNS to the Redis container's IP address
# The decode_responses=True flag ensures Redis returns strings, not bytes
cache = redis.Redis(
    host=os.environ.get("REDIS_HOST", "redis"),
    port=int(os.environ.get("REDIS_PORT", 6379)),
    decode_responses=True
)


@app.route("/health")
def health_check():
    """
    Health check endpoint. Returns HTTP 200 if the service is alive.
    Load balancers and orchestrators use this to determine if the
    container should receive traffic.
    """
    return jsonify({
        "status": "healthy",
        "service": "infrascale-dashboard"
    })


@app.route("/status")
def system_status():
    """
    Returns system status information. Checks Redis cache first;
    if no cached data exists, gathers fresh data and caches it
    for 30 seconds to reduce redundant system calls.
    """

    # Attempt to read cached status from Redis
    cached = None
    try:
        cached = cache.get("system_status")
    except redis.ConnectionError:
        # If Redis is unreachable, continue without cache
        # This demonstrates graceful degradation in distributed systems
        pass

    if cached:
        return jsonify({
            "source": "cache",
            "data": cached
        })

    # Gather fresh system information if cache miss
    status_data = {
        "hostname": socket.gethostname(),
        "platform": platform.platform(),
        "python_version": platform.python_version(),
        "timestamp": datetime.datetime.utcnow().isoformat() + "Z",
        "container_id": os.environ.get("HOSTNAME", "unknown"),
        "uptime_note": "Container started at deployment time"
    }

    # Cache the result in Redis with a 30-second TTL (Time To Live)
    try:
        cache.setex("system_status", 30, str(status_data))
    except redis.ConnectionError:
        pass

    return jsonify({
        "source": "live",
        "data": status_data
    })


@app.route("/")
def index():
    """Root endpoint that returns a welcome message and available routes."""
    return jsonify({
        "service": "InfraScale System Dashboard",
        "version": "1.0.0",
        "module": "04-containerization",
        "endpoints": ["/", "/health", "/status"]
    })


# Start the Flask development server
# Host 0.0.0.0 makes it accessible from outside the container
# Port 5000 is the conventional Flask development port
if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
