;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                                                                                ;
;   MROS Desktop Environment (DDE) for maxregnerOS - Compile with fasm          ;
;   Modern, vibrant desktop environment with enhanced functionality             ;
;                                                                                ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

use32
org 0x0

db 'MENUET01'
dd 0x01
dd START
dd I_END
dd MEM
dd STACKTOP
dd 0x0
dd 0x0

include '../../macros.inc'
include '../../proc32.inc'
include '../../dll.inc'

START:
    ; Initialize MROS Desktop Environment
    call init_desktop
    call draw_desktop
    call main_loop

init_desktop:
    ; Set vibrant background color
    mov eax, 48          ; function 48 - system parameters
    mov ebx, 1           ; subfunction 1 - set background color
    mov ecx, 0x2E86AB    ; vibrant blue background
    mcall
    
    ; Set desktop wallpaper with maxregnerOS branding
    call draw_wallpaper
    ret

draw_desktop:
    ; Clear screen with vibrant background
    mov eax, 12          ; function 12 - begin/end window redraw
    mov ebx, 1           ; begin redraw
    mcall
    
    ; Draw main desktop window
    mov eax, 0           ; function 0 - define window
    mov ebx, 0           ; x position
    mov ecx, 0           ; y position  
    mov edx, 0x2E86AB    ; vibrant blue background
    mov esi, 0x808899AA  ; window style
    mov edi, desktop_title
    mcall
    
    ; Draw maxregnerOS logo/branding
    call draw_branding
    
    ; Draw modern taskbar
    call draw_modern_taskbar
    
    mov eax, 12          ; function 12 - end window redraw
    mov ebx, 2           ; end redraw
    mcall
    ret

draw_branding:
    ; Draw maxregnerOS text in vibrant colors
    mov eax, 4           ; function 4 - draw text
    mov ebx, 50 shl 16 + 50  ; x,y coordinates
    mov ecx, 0xFF6B35    ; vibrant orange text color
    mov edx, brand_text
    mov esi, brand_text_len
    mcall
    
    ; Draw subtitle
    mov eax, 4
    mov ebx, 50 shl 16 + 80
    mov ecx, 0xF7931E    ; bright orange
    mov edx, subtitle_text  
    mov esi, subtitle_text_len
    mcall
    ret

draw_modern_taskbar:
    ; Draw modern taskbar at bottom with vibrant colors
    mov eax, 13          ; function 13 - draw rectangle
    mov ebx, 0 shl 16 + 800  ; x position and width
    mov ecx, 750 shl 16 + 50 ; y position and height (bottom of screen)
    mov edx, 0xFF6B35    ; vibrant orange taskbar
    mcall
    
    ; Draw taskbar text
    mov eax, 4
    mov ebx, 10 shl 16 + 765
    mov ecx, 0xFFFFFF    ; white text
    mov edx, taskbar_text
    mov esi, taskbar_text_len
    mcall
    ret

draw_wallpaper:
    ; Create a gradient wallpaper effect
    mov edi, 0
.gradient_loop:
    mov eax, 13          ; draw rectangle
    mov ebx, 0 shl 16 + 800
    mov ecx, edi shl 16 + 1
    ; Calculate gradient color
    mov edx, 0x2E86AB
    add edx, edi
    and edx, 0xFFFFFF
    mcall
    inc edi
    cmp edi, 600
    jl .gradient_loop
    ret

main_loop:
    ; Main event loop for desktop
    mov eax, 10          ; function 10 - wait for event
    mcall
    
    cmp eax, 1           ; redraw event
    je .redraw
    cmp eax, 2           ; key event  
    je .key
    cmp eax, 3           ; button event
    je .button
    
    jmp main_loop

.redraw:
    call draw_desktop
    jmp main_loop
    
.key:
    mov eax, 2           ; function 2 - get key
    mcall
    ; Handle hotkeys for MROS DDE
    jmp main_loop
    
.button:
    mov eax, 17          ; function 17 - get button
    mcall
    ; Handle desktop buttons
    jmp main_loop

; Data section
desktop_title db 'MROS Desktop Environment',0

brand_text db 'maxregnerOS'
brand_text_len = $ - brand_text

subtitle_text db 'Modern • Vibrant • Powerful'
subtitle_text_len = $ - subtitle_text

taskbar_text db 'MROS DDE - maxregnerOS Desktop Environment'
taskbar_text_len = $ - taskbar_text

I_END:

align 4
MEM:
    rb 0x100000
STACKTOP:

