#!/bin/bash

# Health Check Script for API Avengers Demo App
# This script verifies that the application container is running and healthy

set -e

echo "========================================"
echo "Starting Health Check for Demo App"
echo "========================================"

# Configuration
APP_URL="http://localhost:5000"
HEALTH_ENDPOINT="${APP_URL}/health"
MAX_RETRIES=10
RETRY_INTERVAL=3

# Colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to check if container is running
check_container() {
    echo -e "\n${YELLOW}[1/4] Checking if container is running...${NC}"
    if docker ps | grep -q "api-avengers-demo"; then
        echo -e "${GREEN}✓ Container is running${NC}"
        docker ps | grep "api-avengers-demo"
        return 0
    else
        echo -e "${RED}✗ Container is not running${NC}"
        return 1
    fi
}

# Function to check container health status
check_container_health() {
    echo -e "\n${YELLOW}[2/4] Checking container health status...${NC}"
    HEALTH_STATUS=$(docker inspect --format='{{.State.Health.Status}}' api-avengers-demo 2>/dev/null || echo "none")
    
    if [ "$HEALTH_STATUS" = "healthy" ]; then
        echo -e "${GREEN}✓ Container health status: healthy${NC}"
        return 0
    elif [ "$HEALTH_STATUS" = "none" ]; then
        echo -e "${YELLOW}⚠ Container has no health check configured${NC}"
        return 0
    else
        echo -e "${YELLOW}⚠ Container health status: $HEALTH_STATUS${NC}"
        return 0
    fi
}

# Function to check HTTP health endpoint
check_health_endpoint() {
    echo -e "\n${YELLOW}[3/4] Checking health endpoint...${NC}"
    
    for i in $(seq 1 $MAX_RETRIES); do
        echo "Attempt $i/$MAX_RETRIES: Checking $HEALTH_ENDPOINT"
        
        if curl -s -f -X GET "$HEALTH_ENDPOINT" > /dev/null 2>&1; then
            RESPONSE=$(curl -s -X GET "$HEALTH_ENDPOINT")
            echo -e "${GREEN}✓ Health endpoint is responding${NC}"
            echo "Response: $RESPONSE"
            return 0
        else
            if [ $i -lt $MAX_RETRIES ]; then
                echo "Waiting ${RETRY_INTERVAL}s before retry..."
                sleep $RETRY_INTERVAL
            fi
        fi
    done
    
    echo -e "${RED}✗ Health endpoint did not respond after $MAX_RETRIES attempts${NC}"
    return 1
}

# Function to verify application endpoints
verify_endpoints() {
    echo -e "\n${YELLOW}[4/4] Verifying application endpoints...${NC}"
    
    # Check home endpoint
    echo "Testing home endpoint: ${APP_URL}/"
    HOME_RESPONSE=$(curl -s -X GET "${APP_URL}/" || echo "failed")
    if echo "$HOME_RESPONSE" | grep -q "Hello World"; then
        echo -e "${GREEN}✓ Home endpoint is working${NC}"
    else
        echo -e "${RED}✗ Home endpoint check failed${NC}"
        return 1
    fi
    
    # Check info endpoint
    echo "Testing info endpoint: ${APP_URL}/info"
    INFO_RESPONSE=$(curl -s -X GET "${APP_URL}/info" || echo "failed")
    if echo "$INFO_RESPONSE" | grep -q "API Avengers"; then
        echo -e "${GREEN}✓ Info endpoint is working${NC}"
    else
        echo -e "${RED}✗ Info endpoint check failed${NC}"
        return 1
    fi
    
    return 0
}

# Main execution
main() {
    echo ""
    
    # Run all checks
    if ! check_container; then
        echo -e "\n${RED}========================================${NC}"
        echo -e "${RED}HEALTH CHECK FAILED: Container not running${NC}"
        echo -e "${RED}========================================${NC}"
        exit 1
    fi
    
    check_container_health
    
    if ! check_health_endpoint; then
        echo -e "\n${RED}========================================${NC}"
        echo -e "${RED}HEALTH CHECK FAILED: Endpoint not responding${NC}"
        echo -e "${RED}========================================${NC}"
        exit 1
    fi
    
    if ! verify_endpoints; then
        echo -e "\n${RED}========================================${NC}"
        echo -e "${RED}HEALTH CHECK FAILED: Endpoints not working${NC}"
        echo -e "${RED}========================================${NC}"
        exit 1
    fi
    
    # All checks passed
    echo -e "\n${GREEN}========================================${NC}"
    echo -e "${GREEN}✓ ALL HEALTH CHECKS PASSED${NC}"
    echo -e "${GREEN}========================================${NC}"
    echo -e "\n${GREEN}Application is healthy and ready to serve requests!${NC}"
    echo -e "Access the application at: ${APP_URL}"
    echo ""
    
    exit 0
}

# Run main function
main
