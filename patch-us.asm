; must be built using build.sh

include "pre.asm"

include "ram-us.asm"
include "offsets-us.asm"

VSP_CONTROL_ZERO_VSPEED=$1C

MACRO BANKSWAP bank
    ; unclear why we | $80, but everyone else is doing it...
    lda #((bank << 1) | $80)
    jsr setAndSaveLowerBank
ENDM

include "_improved_controls.asm"
    
; --------------------------------------------------------------------
BANK $F
BASE $C000