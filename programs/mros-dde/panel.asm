;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                                                                                ;
;   MROS Panel - Modern Taskbar for maxregnerOS - Compile with fasm             ;
;   Enhanced taskbar with vibrant colors and modern functionality               ;
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

; Panel configuration
PANEL_HEIGHT = 40
BUTTON_WIDTH = 120
BUTTON_HEIGHT = 30

START:
    call init_panel
    call draw_panel
    call main_loop

init_panel:
    ; Get screen resolution
    mov eax, 14
    mcall
    mov [screen_width], ax
    shr eax, 16
    mov [screen_height], ax
    
    ; Calculate panel position (bottom of screen)
    mov ax, [screen_height]
    sub ax, PANEL_HEIGHT
    mov [panel_y], ax
    ret

draw_panel:
    mov eax, 12          ; begin redraw
    mov ebx, 1
    mcall
    
    ; Define panel window
    mov eax, 0
    mov ebx, 0           ; x = 0
    mov ecx, [panel_y]
    shl ecx, 16
    add ecx, PANEL_HEIGHT ; y = bottom, height = PANEL_HEIGHT
    mov edx, 0x2E86AB    ; vibrant blue background
    or edx, 0x01000000   ; window style
    mov esi, 0x808899AA
    mov edi, panel_title
    mcall
    
    ; Draw start button
    call draw_start_button
    
    ; Draw system tray
    call draw_system_tray
    
    ; Draw clock
    call draw_clock
    
    ; Draw running applications
    call draw_app_buttons
    
    mov eax, 12          ; end redraw
    mov ebx, 2
    mcall
    ret

draw_start_button:
    ; Draw vibrant start button
    mov eax, 8           ; define button
    mov ebx, 5 shl 16 + BUTTON_WIDTH
    mov ecx, 5 shl 16 + BUTTON_HEIGHT
    mov edx, 1           ; button ID
    mov esi, 0xFF6B35    ; vibrant orange
    mcall
    
    ; Draw start button text
    mov eax, 4
    mov ebx, 25 shl 16 + 15
    mov ecx, 0xFFFFFF    ; white text
    mov edx, start_text
    mov esi, start_text_len
    mcall
    ret

draw_system_tray:
    ; Draw system tray area
    mov ax, [screen_width]
    sub ax, 200
    mov ebx, eax
    shl ebx, 16
    add ebx, 150         ; width
    
    mov eax, 13          ; draw rectangle
    mov ecx, 5 shl 16 + 30
    mov edx, 0x0F3460    ; dark blue tray
    mcall
    
    ; Draw tray icons (placeholder)
    mov eax, 4
    mov ebx, (word [screen_width] - 180) shl 16 + 15
    mov ecx, 0xFFFFFF
    mov edx, tray_text
    mov esi, tray_text_len
    mcall
    ret

draw_clock:
    ; Get system time
    mov eax, 3
    mcall
    
    ; Convert time to string (simplified)
    ; Draw clock
    mov ax, [screen_width]
    sub ax, 80
    mov ebx, eax
    shl ebx, 16
    add ebx, 15          ; y position
    
    mov eax, 4
    mov ecx, 0xF7931E    ; bright orange
    mov edx, clock_text
    mov esi, clock_text_len
    mcall
    ret

draw_app_buttons:
    ; Draw buttons for running applications
    mov edi, 0           ; app counter
    mov esi, 140         ; x position (after start button)
    
.draw_app_loop:
    cmp edi, 5           ; max 5 app buttons for demo
    jge .done
    
    ; Draw app button
    mov eax, 8
    mov ebx, esi
    shl ebx, 16
    add ebx, 100         ; button width
    mov ecx, 5 shl 16 + 30
    mov edx, edi
    add edx, 10          ; button ID
    mov eax, 0xC5C6C7    ; light gray for inactive apps
    mcall
    
    ; Draw app text
    mov eax, 4
    mov ebx, esi
    add ebx, 10
    shl ebx, 16
    add ebx, 15
    mov ecx, 0x2C3E50    ; dark text
    mov edx, app_text
    mov eax, app_text_len
    mcall
    
    add esi, 105         ; next button position
    inc edi
    jmp .draw_app_loop
    
.done:
    ret

main_loop:
    mov eax, 10          ; wait for event
    mcall
    
    cmp eax, 1           ; redraw
    je .redraw
    cmp eax, 2           ; key
    je .key  
    cmp eax, 3           ; button
    je .button
    
    jmp main_loop

.redraw:
    call draw_panel
    jmp main_loop
    
.key:
    mov eax, 2
    mcall
    jmp main_loop
    
.button:
    mov eax, 17
    mcall
    
    cmp ah, 1            ; start button
    je .start_menu
    
    ; Handle other buttons
    jmp main_loop
    
.start_menu:
    ; Launch start menu
    call show_start_menu
    jmp main_loop

show_start_menu:
    ; Create popup start menu with vibrant colors
    ; This would show applications, settings, etc.
    ret

; Data section
panel_title db 'MROS Panel',0

start_text db 'maxregnerOS'
start_text_len = $ - start_text

tray_text db 'System'
tray_text_len = $ - tray_text

clock_text db '12:34'
clock_text_len = $ - clock_text

app_text db 'App'
app_text_len = $ - app_text

; Variables
screen_width dw 0
screen_height dw 0
panel_y dw 0

I_END:

align 4
MEM:
    rb 0x100000
STACKTOP:

