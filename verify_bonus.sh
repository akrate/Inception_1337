#!/bin/bash

# Bonus Services Verification Script
# Run this script to verify all bonus services are properly configured

echo "========================================"
echo "Inception Project - Bonus Services Verification"
echo "========================================"

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

check_file() {
    if [ -f "$1" ]; then
        echo -e "${GREEN}✓ $1 exists${NC}"
        return 0
    else
        echo -e "${RED}✗ $1 missing${NC}"
        return 1
    fi
}

check_directory() {
    if [ -d "$1" ]; then
        echo -e "${GREEN}✓ Directory $1 exists${NC}"
        return 0
    else
        echo -e "${RED}✗ Directory $1 missing${NC}"
        return 1
    fi
}

check_dockerfile() {
    local service=$1
    if check_file "srcs/requirements/$service/Dockerfile"; then
        echo -e "  Content check:"
        if grep -q "FROM " "srcs/requirements/$service/Dockerfile"; then
            echo -e "    ${GREEN}✓ Has FROM instruction${NC}"
        else
            echo -e "    ${RED}✗ Missing FROM instruction${NC}"
        fi
        if grep -q "EXPOSE " "srcs/requirements/$service/Dockerfile"; then
            echo -e "    ${GREEN}✓ Has EXPOSE instruction${NC}"
        else
            echo -e "    ${YELLOW}⚠ No EXPOSE instruction (may be intentional)${NC}"
        fi
    fi
}

echo ""
echo "1. Checking directory structure..."
echo "--------------------------------"

services=("redis" "ftp" "static-site" "adminer" "portainer")
all_good=true

for service in "${services[@]}"; do
    echo ""
    echo "Checking $service service:"
    check_directory "srcs/requirements/$service"
    if [ $? -ne 0 ]; then
        all_good=false
        continue
    fi
    
    check_dockerfile "$service"
    check_directory "srcs/requirements/$service/conf"
done

echo ""
echo "2. Checking configuration files..."
echo "--------------------------------"

# Check Redis config
if check_file "srcs/requirements/redis/conf/redis.conf"; then
    if grep -q "maxmemory 256mb" "srcs/requirements/redis/conf/redis.conf"; then
        echo -e "  ${GREEN}✓ Redis memory limit configured${NC}"
    else
        echo -e "  ${YELLOW}⚠ Redis memory limit not found${NC}"
    fi
fi

# Check FTP config
if check_file "srcs/requirements/ftp/conf/vsftpd.conf"; then
    if grep -q "pasv_min_port=40000" "srcs/requirements/ftp/conf/vsftpd.conf"; then
        echo -e "  ${GREEN}✓ FTP passive ports configured${NC}"
    else
        echo -e "  ${YELLOW}⚠ FTP passive ports not configured${NC}"
    fi
fi

# Check static site files
if check_file "srcs/requirements/static-site/html/index.html"; then
    echo -e "  ${GREEN}✓ Static site HTML file exists${NC}"
fi
if check_file "srcs/requirements/static-site/html/css/style.css"; then
    echo -e "  ${GREEN}✓ Static site CSS file exists${NC}"
fi
if check_file "srcs/requirements/static-site/html/js/script.js"; then
    echo -e "  ${GREEN}✓ Static site JavaScript file exists${NC}"
fi

echo ""
echo "3. Checking docker-compose.yml..."
echo "--------------------------------"

if check_file "srcs/docker-compose.yml"; then
    for service in "${services[@]}"; do
        if grep -q "^\s*$service:" "srcs/docker-compose.yml"; then
            echo -e "  ${GREEN}✓ $service service defined${NC}"
        else
            echo -e "  ${RED}✗ $service service missing${NC}"
            all_good=false
        fi
    done
    
    # Check network configuration
    if grep -q "inception-net:" "srcs/docker-compose.yml"; then
        echo -e "  ${GREEN}✓ Docker network defined${NC}"
    else
        echo -e "  ${RED}✗ Docker network missing${NC}"
        all_good=false
    fi
fi

echo ""
echo "4. Checking Makefile..."
echo "------------------------"

if check_file "Makefile"; then
    if grep -q "create_dirs" "Makefile"; then
        echo -e "  ${GREEN}✓ Makefile has create_dirs target${NC}"
    else
        echo -e "  ${YELLOW}⚠ Makefile missing create_dirs target${NC}"
    fi
    
    if grep -q "DATA_DIR.*oussama" "Makefile"; then
        echo -e "  ${GREEN}✓ Makefile uses correct username${NC}"
    else
        echo -e "  ${RED}✗ Makefile has incorrect username${NC}"
        all_good=false
    fi
fi

echo ""
echo "5. Checking documentation..."
echo "---------------------------"

docs=("README.md" "USER_DOC.md" "DEV_DOC.md" "BONUS.md")
for doc in "${docs[@]}"; do
    if check_file "$doc"; then
        # Check if documentation mentions bonus services
        if grep -qi "bonus" "$doc" || grep -qi "redis\|ftp\|static.*site\|adminer\|phpmyadmin" "$doc"; then
            echo -e "  ${GREEN}✓ $doc mentions bonus services${NC}"
        else
            echo -e "  ${YELLOW}⚠ $doc may not mention bonus services${NC}"
        fi
    fi
done

echo ""
echo "========================================"
echo "Verification Summary"
echo "========================================"

if [ "$all_good" = true ]; then
    echo -e "${GREEN}✅ All bonus services appear to be properly configured!${NC}"
    echo ""
    echo "Next steps:"
    echo "1. Run 'make' to build and start all services"
    echo "2. Access services at:"
    echo "   - WordPress: https://oussama.42.fr"
    echo "   - Static Site: http://static.oussama.42.fr:8080"
    echo "   - Adminer: https://adminer.oussama.42.fr:8081"
    echo "   - Portainer: https://portainer.oussama.42.fr:9000"
    echo "   - FTP: ftp://oussama.42.fr:21"
    echo "3. Use 'make help' for available commands"
else
    echo -e "${YELLOW}⚠ Some issues found. Please review the output above.${NC}"
    echo ""
    echo "Common issues to check:"
    echo "1. Missing service directories"
    echo "2. Incorrect paths in docker-compose.yml"
    echo "3. Makefile configuration issues"
    exit 1
fi

echo ""
echo "To test the configuration (requires Docker):"
echo "  make create_dirs  # Create data directories"
echo "  make              # Build and start all services"
echo "  make health       # Check service status"