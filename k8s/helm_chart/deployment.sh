#!/bin/bash

# Color codes for echoes
RESET="\033[0m"
GREEN="\033[32m"
YELLOW="\033[33m"

# Default values for arguments
NAMESPACE="default"
SERVICE1_TAG="latest"
SERVICE2_TAG="latest"
INGRESS_HOST="service2.local"

# Function to show usage
usage() {
  echo "Usage: $0 [options]"
  echo "Options:"
  echo "  --namespace        Kubernetes namespace (default: default)"
  echo "  --service1-tag     Tag for service1 image (default: latest)"
  echo "  --service2-tag     Tag for service2 image (default: latest)"
  echo "  --ingress-host     Host for service2 ingress (default: service2.local)"
  echo "  -h, --help         Display this help message"
  exit 1
}

# Parse command-line arguments
while [[ $# -gt 0 ]]; do
  case $1 in
    --namespace)
      NAMESPACE="$2"
      shift; shift
      ;;
    --service1-tag)
      SERVICE1_TAG="$2"
      shift; shift
      ;;
    --service2-tag)
      SERVICE2_TAG="$2"
      shift; shift
      ;;
    --ingress-host)
      INGRESS_HOST="$2"
      shift; shift
      ;;
    -h|--help)
      usage
      ;;
    *)
      echo "Unknown option: $1"
      usage
      ;;
  esac
done

# Helm install or upgrade
echo -e "${GREEN}Deploying services with Helm...${RESET}"
helm upgrade --install service-chart ./service-chart \
  --namespace $NAMESPACE \
  --create-namespace \
  --set service1.image.tag=$SERVICE1_TAG \
  --set service2.image.tag=$SERVICE2_TAG \
  --set ingress.host=$INGRESS_HOST

echo -e "${GREEN}Deployment completed!${RESET}"

echo -e "${GREEN}Using the following configuration:${RESET}"
echo -e "${YELLOW}Namespace: $NAMESPACE${RESET}"
echo -e "${YELLOW}Service1 Image Tag: $SERVICE1_TAG${RESET}"
echo -e "${YELLOW}Service2 Image Tag: $SERVICE2_TAG${RESET}"
echo -e "${YELLOW}Ingress Host: $INGRESS_HOST${RESET}"
