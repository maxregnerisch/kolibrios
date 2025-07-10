# maxregnerOS

**Modern • Vibrant • Powerful**

maxregnerOS is a complete transformation of KolibriOS into a modern, vibrant operating system featuring the MROS Desktop Environment (DDE) and enhanced user experience.

## 🎨 Features

### Visual Design
- **Vibrant Color Scheme**: Modern color palette with vibrant blues, oranges, and contemporary styling
- **Custom Skin System**: maxregnerOS-vibrant skin with modern UI elements
- **Enhanced Typography**: Improved fonts and text rendering
- **Modern Icons**: Contemporary iconography throughout the system

### MROS Desktop Environment (DDE)
- **Modern Desktop Manager**: Handles wallpaper, desktop icons, and system integration
- **Enhanced Taskbar**: Modern panel with start menu, running apps, system tray, and clock
- **Window Management**: Improved window decorations and management
- **System Integration**: Seamless integration with system services

### Technical Improvements
- **Optimized Kernel**: Enhanced KolibriOS kernel with maxregnerOS branding
- **Build System**: Comprehensive build scripts for easy compilation
- **Modular Design**: Clean separation of components for easy maintenance
- **Future-Ready**: Architecture prepared for Linux application support

## 🎯 Color Scheme

maxregnerOS uses a carefully designed color palette:

| Color | Hex Code | Usage |
|-------|----------|-------|
| Primary Blue | `#2E86AB` | Main UI elements, taskbar |
| Vibrant Orange | `#FF6B35` | Accent color, buttons, highlights |
| Bright Orange | `#F7931E` | Secondary accent, window titles |
| Dark Blue | `#0F3460` | Shadows, inactive elements |
| Light Gray | `#C5C6C7` | Neutral elements |
| White | `#FFFFFF` | Text, clean backgrounds |
| Dark Text | `#2C3E50` | Primary text color |

## 🏗️ Project Structure

```
maxregnerOS/
├── kernel/trunk/           # Enhanced kernel with maxregnerOS branding
├── programs/mros-dde/      # MROS Desktop Environment
│   ├── desktop.asm         # Desktop manager
│   ├── panel.asm          # Modern taskbar/panel
│   └── README.md          # DDE documentation
├── skins/maxregnerOS-vibrant/  # Custom vibrant skin
│   ├── default.asm        # Main skin definition
│   ├── dtp.asm           # Desktop theme parameters
│   └── *.bmp             # UI element bitmaps
├── scripts/               # Build and deployment scripts
│   ├── build-maxregneros-iso.sh    # ISO builder
│   ├── upload-iso.sh              # Upload to bash upload.com
│   └── build-and-upload.sh        # Complete pipeline
└── README-maxregnerOS.md  # This file
```

## 🚀 Quick Start

### Prerequisites
- FASM assembler
- Build tools (make, gcc)
- ISO creation tools (genisoimage or mkisofs)
- curl (for uploading)

### Building maxregnerOS

1. **Clone the repository**:
   ```bash
   git clone https://github.com/maxregnerisch/kolibrios.git
   cd kolibrios
   ```

2. **Build and upload in one command**:
   ```bash
   ./scripts/build-and-upload.sh
   ```

3. **Or build step by step**:
   ```bash
   # Build ISO
   ./scripts/build-maxregneros-iso.sh
   
   # Upload to bash upload.com
   ./scripts/upload-iso.sh
   ```

### Manual Building

If you prefer to build components individually:

```bash
# Build MROS Desktop Environment
cd programs/mros-dde
fasm desktop.asm desktop
fasm panel.asm panel

# Build vibrant skin
cd ../../skins/maxregnerOS-vibrant
fasm default.asm default.skn
fasm dtp.asm dtp.dtp

# Build kernel (if needed)
cd ../../kernel/trunk
# Follow kernel build instructions
```

## 📦 Components

### MROS Desktop Environment
The heart of maxregnerOS, providing:
- Modern desktop management
- Enhanced taskbar with system tray
- Application launcher and management
- System integration and hotkeys

### maxregnerOS-vibrant Skin
Custom skin system featuring:
- Vibrant color scheme implementation
- Modern window decorations
- Enhanced visual elements
- Consistent theming across applications

### Enhanced Kernel
Based on KolibriOS kernel with:
- maxregnerOS branding and version info
- Optimizations for modern hardware
- Enhanced system calls and services
- Preparation for Linux app compatibility

## 🔧 Development

### Building from Source
1. Install FASM assembler
2. Clone the repository
3. Run build scripts or build components manually
4. Test in virtual machine or real hardware

### Contributing
Areas where contributions are welcome:
- UI/UX improvements
- Additional desktop components
- Performance optimizations
- Linux application compatibility layer
- Documentation and tutorials

### Code Style
- Follow existing assembly code conventions
- Use meaningful variable and function names
- Comment complex algorithms and system interactions
- Maintain consistency with the vibrant color scheme

## 🌟 Future Roadmap

### Short Term
- [ ] Enhanced application launcher with search
- [ ] Desktop widgets and gadgets
- [ ] Window effects and animations
- [ ] System settings GUI
- [ ] File manager integration

### Medium Term
- [ ] Linux application compatibility layer
- [ ] Package management system
- [ ] Network configuration tools
- [ ] Multimedia enhancements
- [ ] Developer tools integration

### Long Term
- [ ] Full Linux application support
- [ ] Modern web browser integration
- [ ] Cloud services integration
- [ ] Mobile device synchronization
- [ ] Advanced security features

## 📋 System Requirements

### Minimum Requirements
- 32-bit x86 processor
- 32 MB RAM
- VGA-compatible graphics
- PS/2 or USB keyboard/mouse
- CD-ROM or USB boot capability

### Recommended Requirements
- Modern x86 processor
- 128 MB RAM or more
- SVGA graphics with 1024x768 resolution
- USB keyboard and mouse
- Network adapter for future features

## 🤝 Community

### Getting Help
- Check the documentation in each component's README
- Review the build scripts for troubleshooting
- Examine the source code for implementation details

### Reporting Issues
When reporting issues, please include:
- System specifications
- Build environment details
- Steps to reproduce the problem
- Expected vs actual behavior

## 📄 License

maxregnerOS is based on KolibriOS and maintains compatibility with its licensing terms. Additional components and modifications are provided under the same open-source principles.

## 🙏 Acknowledgments

- **KolibriOS Team**: For the excellent foundation operating system
- **FASM Community**: For the powerful assembler
- **Open Source Community**: For tools and inspiration

---

**maxregnerOS** - *Bringing modern, vibrant computing to everyone* 🚀

*Built with ❤️ for the future of lightweight operating systems*

