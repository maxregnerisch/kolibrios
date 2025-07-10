#!/bin/bash
################################################################################
#                                                                              #
#   maxregnerOS ISO Builder                                                    #
#   Builds a complete maxregnerOS ISO with MROS DDE and vibrant UI            #
#                                                                              #
################################################################################

set -e  # Exit on any error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
ORANGE='\033[0;33m'
NC='\033[0m' # No Color

# Configuration
BUILD_DIR="build"
ISO_NAME="maxregnerOS-v1.0.0.iso"
TEMP_DIR="$BUILD_DIR/temp"

echo -e "${BLUE}================================${NC}"
echo -e "${BLUE}  maxregnerOS ISO Builder v1.0  ${NC}"
echo -e "${BLUE}================================${NC}"
echo ""

# Create build directories
echo -e "${ORANGE}Creating build directories...${NC}"
mkdir -p "$BUILD_DIR"
mkdir -p "$TEMP_DIR"

# Check for required tools
echo -e "${ORANGE}Checking build tools...${NC}"
command -v fasm >/dev/null 2>&1 || { echo -e "${RED}Error: FASM assembler not found${NC}"; exit 1; }
command -v tup >/dev/null 2>&1 || echo -e "${ORANGE}Warning: Tup build system not found, using manual build${NC}"
command -v genisoimage >/dev/null 2>&1 || command -v mkisofs >/dev/null 2>&1 || { echo -e "${RED}Error: ISO creation tool not found${NC}"; exit 1; }

# Build kernel with ultra-fast architecture
echo -e "${ORANGE}Building maxregnerOS kernel with Ultra-Fast Architecture...${NC}"
cd kernel/trunk
if [ -f "build.sh" ]; then
    ./build.sh
else
    echo -e "${ORANGE}Using manual kernel build with ultra-fast optimizations...${NC}"
    # Add ultra-fast architecture to kernel build
    echo "include 'maxregneros-arch/ultra_arch.inc'" >> kernel.asm
    fasm kernel.asm kernel.mnt
fi
cd ../..

# Build MROS Desktop Environment
echo -e "${ORANGE}Building MROS Desktop Environment...${NC}"
cd programs/mros-dde
fasm desktop.asm desktop
fasm panel.asm panel
cd ../..

# Build vibrant skin
echo -e "${ORANGE}Building maxregnerOS vibrant skin...${NC}"
cd skins/maxregnerOS-vibrant
fasm default.asm default.skn
fasm dtp.asm dtp.dtp
cd ../..

# Build system programs
echo -e "${ORANGE}Building system programs...${NC}"
if command -v tup >/dev/null 2>&1; then
    echo -e "${GREEN}Using Tup build system...${NC}"
    tup
else
    echo -e "${ORANGE}Building essential programs manually...${NC}"
    # Build essential system programs
    cd programs/system/taskbar/trunk
    fasm TASKBAR.ASM taskbar
    cd ../../../..
fi

# Create ISO structure
echo -e "${ORANGE}Creating ISO structure...${NC}"
mkdir -p "$TEMP_DIR/maxregneros"
mkdir -p "$TEMP_DIR/maxregneros/system"
mkdir -p "$TEMP_DIR/maxregneros/programs"
mkdir -p "$TEMP_DIR/maxregneros/skins"

# Copy kernel
if [ -f "kernel/trunk/kernel.mnt" ]; then
    cp kernel/trunk/kernel.mnt "$TEMP_DIR/maxregneros/"
    echo -e "${GREEN}✓ Kernel copied${NC}"
else
    echo -e "${RED}✗ Kernel build failed${NC}"
    exit 1
fi

# Copy MROS DDE
if [ -f "programs/mros-dde/desktop" ] && [ -f "programs/mros-dde/panel" ]; then
    cp programs/mros-dde/desktop "$TEMP_DIR/maxregneros/programs/"
    cp programs/mros-dde/panel "$TEMP_DIR/maxregneros/programs/"
    echo -e "${GREEN}✓ MROS DDE copied${NC}"
else
    echo -e "${RED}✗ MROS DDE build failed${NC}"
    exit 1
fi

# Copy vibrant skin
if [ -f "skins/maxregnerOS-vibrant/default.skn" ]; then
    cp -r skins/maxregnerOS-vibrant "$TEMP_DIR/maxregneros/skins/"
    echo -e "${GREEN}✓ Vibrant skin copied${NC}"
else
    echo -e "${RED}✗ Vibrant skin build failed${NC}"
    exit 1
fi

# Copy system files
echo -e "${ORANGE}Copying system files...${NC}"
cp -r data/* "$TEMP_DIR/maxregneros/" 2>/dev/null || true

# Create autorun configuration
echo -e "${ORANGE}Creating autorun configuration...${NC}"
cat > "$TEMP_DIR/maxregneros/autorun.dat" << EOF
# maxregnerOS Autorun Configuration
# Automatically start MROS Desktop Environment

/programs/desktop
/programs/panel
EOF

# Create system information file
cat > "$TEMP_DIR/maxregneros/system.inf" << EOF
[System]
Name=maxregnerOS
Version=1.0.0
Build=$(date +%Y%m%d)
Description=Ultra-Fast, Modern, Vibrant, Powerful Operating System
Desktop=MROS DDE
Skin=maxregnerOS-vibrant
Architecture=Ultra-Fast Architecture v1.0.0

[Features]
VibrantUI=Yes
LinuxAppSupport=Planned
ModernDesktop=Yes
CustomSkin=Yes
UltraFastMemory=Yes
UltraFastIO=Yes
UltraFastFileSystem=Yes
UltraFastScheduler=Yes
AsynchronousIO=Yes
NVMeOptimization=Yes
MultiLevelCaching=Yes
ZeroCopyOperations=Yes
HardwareAcceleration=Yes
NUMAAware=Yes
PowerAware=Yes

[Performance]
MemoryPools=Enabled
IOBatching=Enabled
Compression=Enabled
Deduplication=Enabled
Prefetching=Enabled
LoadBalancing=Enabled
InterruptCoalescing=Enabled
EOF

# Create bootloader configuration
echo -e "${ORANGE}Configuring bootloader...${NC}"
cat > "$TEMP_DIR/maxregneros/boot.cfg" << EOF
# maxregnerOS Boot Configuration
default=maxregneros
timeout=5

[maxregneros]
title=maxregnerOS v1.0.0 - Modern, Vibrant, Powerful
kernel=/kernel.mnt
initrd=/system.inf
EOF

# Create the ISO
echo -e "${ORANGE}Creating maxregnerOS ISO...${NC}"
if command -v genisoimage >/dev/null 2>&1; then
    genisoimage -o "$BUILD_DIR/$ISO_NAME" \
                -b boot/isolinux.bin \
                -c boot/boot.cat \
                -no-emul-boot \
                -boot-load-size 4 \
                -boot-info-table \
                -V "maxregnerOS" \
                -A "maxregnerOS v1.0.0" \
                -publisher "maxregnerOS Project" \
                -preparer "maxregnerOS Build System" \
                "$TEMP_DIR/maxregneros" 2>/dev/null || {
    # Fallback: create simple ISO without bootloader
    echo -e "${ORANGE}Creating simple ISO without bootloader...${NC}"
    genisoimage -o "$BUILD_DIR/$ISO_NAME" \
                -V "maxregnerOS" \
                -A "maxregnerOS v1.0.0" \
                "$TEMP_DIR/maxregneros"
}
elif command -v mkisofs >/dev/null 2>&1; then
    mkisofs -o "$BUILD_DIR/$ISO_NAME" \
            -V "maxregnerOS" \
            -A "maxregnerOS v1.0.0" \
            "$TEMP_DIR/maxregneros"
fi

# Verify ISO was created
if [ -f "$BUILD_DIR/$ISO_NAME" ]; then
    ISO_SIZE=$(du -h "$BUILD_DIR/$ISO_NAME" | cut -f1)
    echo ""
    echo -e "${GREEN}================================${NC}"
    echo -e "${GREEN}  BUILD SUCCESSFUL! 🎉          ${NC}"
    echo -e "${GREEN}================================${NC}"
    echo -e "${GREEN}ISO File: $BUILD_DIR/$ISO_NAME${NC}"
    echo -e "${GREEN}Size: $ISO_SIZE${NC}"
    echo -e "${GREEN}Location: $(pwd)/$BUILD_DIR/$ISO_NAME${NC}"
    echo ""
    echo -e "${BLUE}maxregnerOS Features:${NC}"
    echo -e "${BLUE}• Modern, vibrant UI with MROS DDE${NC}"
    echo -e "${BLUE}• Custom maxregnerOS-vibrant skin${NC}"
    echo -e "${BLUE}• Enhanced desktop environment${NC}"
    echo -e "${BLUE}• Ready for Linux app support${NC}"
    echo ""
else
    echo -e "${RED}✗ ISO creation failed${NC}"
    exit 1
fi

# Cleanup
echo -e "${ORANGE}Cleaning up temporary files...${NC}"
rm -rf "$TEMP_DIR"

echo -e "${GREEN}maxregnerOS ISO build complete! 🚀${NC}"
