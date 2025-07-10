# MROS Desktop Environment (DDE)

The **MROS Desktop Environment** is a modern, vibrant desktop environment designed specifically for maxregnerOS. It provides a contemporary user interface with enhanced functionality while maintaining the efficiency of the underlying KolibriOS foundation.

## Features

🎨 **Vibrant Visual Design**
- Modern color scheme with vibrant blues, oranges, and contemporary styling
- Gradient backgrounds and smooth visual elements
- Enhanced typography and iconography

🖥️ **Modern Desktop Components**
- **Desktop Manager**: Handles wallpaper, desktop icons, and background processes
- **Panel/Taskbar**: Modern taskbar with start menu, running applications, system tray, and clock
- **Window Management**: Enhanced window decorations and management

⚡ **Enhanced Functionality**
- Improved application launcher
- Modern system tray with status indicators
- Enhanced keyboard shortcuts and hotkeys
- Better multi-tasking support

## Components

### Desktop (`desktop.asm`)
The main desktop manager that handles:
- Desktop wallpaper and background
- Desktop icons and shortcuts
- System-wide hotkeys
- Desktop context menu

### Panel (`panel.asm`)
The modern taskbar component featuring:
- Start button with maxregnerOS branding
- Running application buttons
- System tray area
- Digital clock
- Modern visual styling

## Building

To build the MROS DDE components:

```bash
# Using FASM directly
fasm desktop.asm desktop
fasm panel.asm panel

# Or using the build script
./build.bat
```

## Installation

1. Build the components using the instructions above
2. Copy the built executables to the system directory
3. Configure the system to use MROS DDE as the default desktop environment
4. Apply the maxregnerOS-vibrant skin for the complete visual experience

## Color Scheme

The MROS DDE uses a carefully designed color palette:

- **Primary Blue**: `#2E86AB` - Main UI elements, taskbar
- **Vibrant Orange**: `#FF6B35` - Accent color, buttons, highlights  
- **Bright Orange**: `#F7931E` - Secondary accent, window titles
- **Dark Blue**: `#0F3460` - Shadows, inactive elements
- **Light Gray**: `#C5C6C7` - Neutral elements
- **White**: `#FFFFFF` - Text, clean backgrounds
- **Dark Text**: `#2C3E50` - Primary text color

## Future Enhancements

- Application launcher with search
- Desktop widgets and gadgets
- Enhanced window effects and animations
- Customizable themes and color schemes
- Integration with Linux application compatibility layer
- Modern file manager integration
- System settings and configuration tools

## Contributing

Contributions to the MROS Desktop Environment are welcome! Areas where help is needed:

- UI/UX improvements and modern design elements
- Additional desktop widgets and components
- Performance optimizations
- Integration with system services
- Documentation and user guides

---

*MROS DDE - Bringing modern desktop computing to maxregnerOS*

