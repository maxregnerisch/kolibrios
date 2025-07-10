#!/bin/bash
################################################################################
#                                                                              #
#   maxregnerOS ISO Uploader                                                   #
#   Uploads the built maxregnerOS ISO to bash upload.com                      #
#                                                                              #
################################################################################

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
ORANGE='\033[0;33m'
NC='\033[0m'

# Configuration
BUILD_DIR="build"
ISO_NAME="maxregnerOS-v1.0.0.iso"
ISO_PATH="$BUILD_DIR/$ISO_NAME"
UPLOAD_URL="https://bashupload.com"

echo -e "${BLUE}================================${NC}"
echo -e "${BLUE}  maxregnerOS ISO Uploader      ${NC}"
echo -e "${BLUE}================================${NC}"
echo ""

# Check if ISO exists
if [ ! -f "$ISO_PATH" ]; then
    echo -e "${RED}Error: ISO file not found at $ISO_PATH${NC}"
    echo -e "${ORANGE}Please run the build script first: ./scripts/build-maxregneros-iso.sh${NC}"
    exit 1
fi

# Get ISO file size
ISO_SIZE=$(du -h "$ISO_PATH" | cut -f1)
echo -e "${ORANGE}Found ISO: $ISO_PATH ($ISO_SIZE)${NC}"

# Check for curl
if ! command -v curl >/dev/null 2>&1; then
    echo -e "${RED}Error: curl is required for uploading${NC}"
    exit 1
fi

echo -e "${ORANGE}Uploading to bash upload.com...${NC}"
echo ""

# Upload the ISO file
UPLOAD_RESPONSE=$(curl -s --upload-file "$ISO_PATH" "$UPLOAD_URL/$ISO_NAME" || {
    echo -e "${RED}Upload failed!${NC}"
    exit 1
})

# Check if upload was successful
if [ -n "$UPLOAD_RESPONSE" ]; then
    echo -e "${GREEN}================================${NC}"
    echo -e "${GREEN}  UPLOAD SUCCESSFUL! 🎉         ${NC}"
    echo -e "${GREEN}================================${NC}"
    echo ""
    echo -e "${GREEN}maxregnerOS ISO has been uploaded!${NC}"
    echo ""
    echo -e "${BLUE}Download URL:${NC}"
    echo -e "${GREEN}$UPLOAD_RESPONSE${NC}"
    echo ""
    echo -e "${BLUE}File Details:${NC}"
    echo -e "${BLUE}• Name: $ISO_NAME${NC}"
    echo -e "${BLUE}• Size: $ISO_SIZE${NC}"
    echo -e "${BLUE}• Upload Date: $(date)${NC}"
    echo ""
    echo -e "${ORANGE}Share this URL to distribute maxregnerOS!${NC}"
    echo ""
    
    # Save download URL to file
    echo "$UPLOAD_RESPONSE" > "$BUILD_DIR/download-url.txt"
    echo -e "${GREEN}Download URL saved to: $BUILD_DIR/download-url.txt${NC}"
    
else
    echo -e "${RED}Upload failed - no response received${NC}"
    exit 1
fi

echo -e "${GREEN}maxregnerOS ISO upload complete! 🚀${NC}"

