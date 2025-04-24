#!/bin/bash

# Colors for terminal output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}Scholar Jim Application Launcher${NC}"
echo -e "=================================="

# Start the FIS server in the background
echo -e "${YELLOW}Starting FIS Server...${NC}"
(cd scripts && chmod +x run_fis_server.sh && ./run_fis_server.sh) &
FIS_PID=$!

# Give the server some time to start up
echo -e "Waiting for server to initialize..."
sleep 5

# Check if server is running
if ps -p $FIS_PID > /dev/null; then
    echo -e "${GREEN}FIS Server started successfully!${NC}"
else
    echo -e "${RED}Failed to start FIS server. Check scripts/run_fis_server.sh for errors.${NC}"
    exit 1
fi

# When Flutter app terminates, kill the FIS server
echo -e "${YELLOW}Terminating FIS server...${NC}"
kill $FIS_PID

echo -e "${GREEN}Done!${NC}" 