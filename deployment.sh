#!/bin/bash

# Color codes for echoes
RESET="\033[0m"
GREEN="\033[32m"
YELLOW="\033[33m"

# Defaults
SERVICE1_TAG="latest"
SERVICE2_TAG="latest"
SERVICE2_PORT="8080"
NETWORK_NAME="demo_network"

# Help message
usage() {
  echo -e "${YELLOW}Usage: $0 [OPTIONS]${RESET}"
  echo ""
  echo "Options:"
  echo "  --service1_tag=<tag>    Docker tag for service1 (default: latest)"
  echo "  --service2_tag=<tag>    Docker tag for service2 (default: latest)"
  echo "  --port=<port>           Port to expose for service2 (default: 8080)"
  echo "  --network=<name>        Name of the Docker network (default: demo_network)"
  echo ""
  echo "Examples:"
  echo "  $0                          # Deploy with default values"
  echo "  $0 --service1_tag=v1.0.0 --service2_tag=v1.0.0 --port=9090 --network=my_network"
  exit 0
}

# Parse arguments
for arg in "$@"; do
  case $arg in
    --service1_tag=*)
      SERVICE1_TAG="${arg#*=}"
      shift
      ;;
    --service2_tag=*)
      SERVICE2_TAG="${arg#*=}"
      shift
      ;;
    --port=*)
      SERVICE2_PORT="${arg#*=}"
      shift
      ;;
    --network=*)
      NETWORK_NAME="${arg#*=}"
      shift
      ;;
    -h|--help)
      usage
      ;;
    *)
      echo -e "${YELLOW}Unknown argument: $arg${RESET}"
      usage
      ;;
  esac
done

echo -e "${GREEN}Using the following configuration:${RESET}"
echo -e "  ${YELLOW}SERVICE1_TAG:${RESET} $SERVICE1_TAG"
echo -e "  ${YELLOW}SERVICE2_TAG:${RESET} $SERVICE2_TAG"
echo -e "  ${YELLOW}SERVICE2_PORT:${RESET} $SERVICE2_PORT"
echo -e "  ${YELLOW}NETWORK_NAME:${RESET} $NETWORK_NAME"

# Creation of network (for easier communication between containers)
echo -e "${GREEN}Creating Docker network...${RESET}"
docker network inspect $NETWORK_NAME >/dev/null 2>&1 || \
  docker network create $NETWORK_NAME

# Deployment (delete existing containers if they exist, and recreate them)
echo -e "${GREEN}Creating and running containers...${RESET}"
if docker ps -a --format '{{.Names}}' | grep -q "^service1$"; then
  echo -e "${YELLOW}Removing existing service1 container...${RESET}"
  docker rm -f service1
fi

if docker ps -a --format '{{.Names}}' | grep -q "^service2$"; then
  echo -e "${YELLOW}Removing existing service2 container...${RESET}"
  docker rm -f service2
fi

docker run -d --name service1 --network $NETWORK_NAME pjuwy/service1:$SERVICE1_TAG

SERVICE1_URL="http://service1:8080"

docker run -d --name service2 --network $NETWORK_NAME -e SERVICE1_URL=$SERVICE1_URL -p $SERVICE2_PORT:8080 pjuwy/service2:$SERVICE2_TAG

sleep 5

# Testing
echo -e "${GREEN}Sending POST request to service2...${RESET}"
curl -X POST "http://localhost:$SERVICE2_PORT" -d "http://www.google.com"

echo -e "${GREEN}Deployment and test complete!${RESET}"
