
#!/usr/bin/env bash

# ══════════════════════════════════════════════════════════════════
# InfraScale Module 04 — Container Management Script
# ══════════════════════════════════════════════════════════════════
# Usage: ./manage.sh [start|stop|restart|status|logs|clean|push]
# ══════════════════════════════════════════════════════════════════

# Paths
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
COMPOSE_DIR="${SCRIPT_DIR}/../compose"
REGISTRY_DIR="${SCRIPT_DIR}/../registry"

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Functions
print_status() {
    echo -e "${GREEN}[InfraScale]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Main logic
case "${1}" in
    start)
        print_status "Starting InfraScale container stack..."
        docker compose -f "${REGISTRY_DIR}/docker-compose.registry.yml" up -d
        docker compose -f "${COMPOSE_DIR}/docker-compose.yml" up -d --build
        print_status "All services started."
        ;;

    stop)
        print_status "Stopping InfraScale container stack..."
        docker compose -f "${COMPOSE_DIR}/docker-compose.yml" down
        docker compose -f "${REGISTRY_DIR}/docker-compose.registry.yml" down
        print_status "All services stopped."
        ;;

    restart)
        $0 stop
        sleep 2
        $0 start
        ;;

    status)
        print_status "=== Container Status ==="
        docker compose -f "${COMPOSE_DIR}/docker-compose.yml" ps

        echo ""
        print_status "=== Registry Status ==="
        docker compose -f "${REGISTRY_DIR}/docker-compose.registry.yml" ps

        echo ""
        print_status "=== Resource Usage ==="
        docker stats --no-stream --format \
        "table {{.Name}}\t{{.CPUPerc}}\t{{.MemUsage}}\t{{.NetIO}}"
        ;;

    logs)
        if [ -n "${2}" ]; then
            docker compose -f "${COMPOSE_DIR}/docker-compose.yml" logs -f "${2}"
        else
            docker compose -f "${COMPOSE_DIR}/docker-compose.yml" logs -f
        fi
        ;;

    clean)
        print_status "Cleaning up stopped containers, unused images, and build cache..."
        docker system prune -f
        print_status "Cleanup complete."
        ;;

    push)
        REGISTRY="${2:-localhost:5000}"
        print_status "Pushing images to ${REGISTRY}..."

        docker compose -f "${COMPOSE_DIR}/docker-compose.yml" build

        docker tag compose-webapp:latest "${REGISTRY}/infrascale/dashboard:latest"
        docker tag compose-nginx:latest "${REGISTRY}/infrascale/proxy:latest"

        docker push "${REGISTRY}/infrascale/dashboard:latest"
        docker push "${REGISTRY}/infrascale/proxy:latest"

        print_status "Push complete. Catalog:"
        curl -s "http://${REGISTRY}/v2/_catalog" | python3 -m json.tool
        ;;

    *)
        echo "Usage: $0 {start|stop|restart|status|logs|clean|push}"
        echo ""
        echo "  start     Start all InfraScale containers"
        echo "  stop      Stop all InfraScale containers"
        echo "  restart   Restart all containers"
        echo "  status    Show container status and resource usage"
        echo "  logs      [service] Follow logs (optional service)"
        echo "  clean     Remove stopped containers and unused images"
        echo "  push      [registry] Push images (default: localhost:5000)"
        exit 1
        ;;
esac
