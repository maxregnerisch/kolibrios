include '../../skin.inc'

SKIN_PARAMS \
  height          = bmp_center1.height,\  ; skin height
  margins         = [8:6:8:4],\           ; margins [left:top:right:bottom] - slightly larger for modern look
  colors active   = [binner=0xFF6B35:\    ; vibrant orange border inner
                     bouter=0x2E86AB:\    ; vibrant blue border outer  
                     bframe=0xF7931E],\   ; bright orange border middle
  colors inactive = [binner=0xC5C6C7:\    ; light gray border inner
                     bouter=0x0F3460:\    ; dark blue border outer
                     bframe=0xC5C6C7],\   ; light gray border middle
  dtp             = 'dtp.dtp'          ; dtp colors

SKIN_BUTTONS \
  close    = [-32:2][28:20],\             ; buttons coordinates - slightly larger
  minimize = [-64:2][28:20]               ; [left:top][width:height]

SKIN_BITMAPS \
  left active   = bmp_left1,\              ; skin bitmaps pointers
  left inactive = bmp_left2,\
  oper active   = bmp_right1,\
  oper inactive = bmp_right2,\
  base active   = bmp_center1,\
  base inactive = bmp_center2

BITMAP bmp_left1,  'left1.bmp'               ; skin bitmaps
BITMAP bmp_left2,  'left2.bmp'
BITMAP bmp_right1, 'right1.bmp'
BITMAP bmp_right2, 'right2.bmp'
BITMAP bmp_center1,'center1.bmp'
BITMAP bmp_center2,'center2.bmp'

