@echo off
echo Building MROS Desktop Environment...
fasm desktop.asm desktop
fasm panel.asm panel
echo MROS DDE build complete!
pause

