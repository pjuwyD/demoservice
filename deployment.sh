#!/bin/bash


SERVICE1_TAG="latest"
SERVICE2_TAG="latest"
SERVICE2_PORT="8080"
NETWORK_NAME="demo_network"


usage() {
  echo "Usage: $0 [OPTIONS]"
  echo ""
  echo "Options:"
  echo "  -h, --help            Show this help message and exit"
  echo "  SERVICE1_TAG          Docker tag for service1 (default: latest)"
  echo "  SERVICE2_TAG          Docker tag for service2 (default: latest)"
  echo "  SERVICE2_PORT         Port to expose for service2 (default: 8080)"
  echo "  NETWORK_NAME          Name of the Docker network (default: demo_network)"
  echo ""
  echo "Examples:"
  echo "  $0                     # Deploy with default values"
  echo "  $0 v1.0.0 v1.0.0 9090 my_network   # Deploy with custom values"
  exit 0
}


if [[ "$1" == "-h" || "$1" == "--help" ]]; then
  usage
fi


if [ $# -ge 1 ]; then
  SERVICE1_TAG=$1
fi
if [ $# -ge 2 ]; then
  SERVICE2_TAG=$2
fi
if [ $# -ge 3 ]; then
  SERVICE2_PORT=$3
fi
if [ $# -ge 4 ]; then
  NETWORK_NAME=$4
fi


echo "Creating Docker network..."

docker network inspect $NETWORK_NAME >/dev/null 2>&1 || \
  docker network create $NETWORK_NAME

echo "Creating and running containers..."

docker run -d --name service1 --network $NETWORK_NAME pjuwy/service1:$SERVICE1_TAG

SERVICE1_URL="http://service1:8080"

docker run -d --name service2 --network $NETWORK_NAME -e SERVICE1_URL=$SERVICE1_URL -p $SERVICE2_PORT:8080 pjuwy/service2:$SERVICE2_TAG

sleep 5

echo "Sending POST request to service2..."

curl -X POST "http://localhost:$SERVICE2_PORT" -d "http://www.google.com"

echo "Deployment and test complete!"
