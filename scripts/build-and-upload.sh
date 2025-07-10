#!/bin/bash
################################################################################
#                                                                              #
#   maxregnerOS Complete Build & Upload Pipeline                              #
#   Builds maxregnerOS ISO and uploads it to bash upload.com                  #
#                                                                              #
################################################################################

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
ORANGE='\033[0;33m'
PURPLE='\033[0;35m'
NC='\033[0m'

echo -e "${PURPLE}████████████████████████████████████████████████████████${NC}"
echo -e "${PURPLE}█                                                      █${NC}"
echo -e "${PURPLE}█              maxregnerOS Build Pipeline             █${NC}"
echo -e "${PURPLE}█          Modern • Vibrant • Powerful                █${NC}"
echo -e "${PURPLE}█                                                      █${NC}"
echo -e "${PURPLE}████████████████████████████████████████████████████████${NC}"
echo ""

# Step 1: Build the ISO
echo -e "${BLUE}Step 1: Building maxregnerOS ISO...${NC}"
echo -e "${ORANGE}Running build script...${NC}"
./scripts/build-maxregneros-iso.sh

if [ $? -eq 0 ]; then
    echo -e "${GREEN}✓ ISO build completed successfully${NC}"
else
    echo -e "${RED}✗ ISO build failed${NC}"
    exit 1
fi

echo ""

# Step 2: Upload the ISO
echo -e "${BLUE}Step 2: Uploading maxregnerOS ISO...${NC}"
echo -e "${ORANGE}Running upload script...${NC}"
./scripts/upload-iso.sh

if [ $? -eq 0 ]; then
    echo -e "${GREEN}✓ ISO upload completed successfully${NC}"
else
    echo -e "${RED}✗ ISO upload failed${NC}"
    exit 1
fi

echo ""
echo -e "${PURPLE}████████████████████████████████████████████████████████${NC}"
echo -e "${PURPLE}█                                                      █${NC}"
echo -e "${PURPLE}█            🎉 PIPELINE COMPLETE! 🎉                 █${NC}"
echo -e "${PURPLE}█                                                      █${NC}"
echo -e "${PURPLE}█  maxregnerOS has been built and uploaded!           █${NC}"
echo -e "${PURPLE}█                                                      █${NC}"
echo -e "${PURPLE}████████████████████████████████████████████████████████${NC}"
echo ""

# Display summary
if [ -f "build/download-url.txt" ]; then
    DOWNLOAD_URL=$(cat build/download-url.txt)
    echo -e "${GREEN}🔗 Download URL: $DOWNLOAD_URL${NC}"
    echo ""
fi

echo -e "${BLUE}What's included in maxregnerOS:${NC}"
echo -e "${GREEN}• 🎨 Vibrant UI with custom color scheme${NC}"
echo -e "${GREEN}• 🖥️  MROS Desktop Environment (DDE)${NC}"
echo -e "${GREEN}• 🎯 Modern taskbar and window management${NC}"
echo -e "${GREEN}• ⚡ Lightweight and efficient kernel${NC}"
echo -e "${GREEN}• 🚀 Ready for future Linux app support${NC}"
echo ""
echo -e "${ORANGE}Thank you for using maxregnerOS! 🌟${NC}"

