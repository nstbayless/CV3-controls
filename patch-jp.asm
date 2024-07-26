; must be built using build.sh

include "pre.asm"

include "ram-jp.asm"
include "offsets-jp.asm"

VSP_CONTROL_ZERO_VSPEED=$1C

MACRO BANKSWAP bank
    lda #bank
    jsr setAndSaveLowerBank
ENDM

include "_improved_controls.asm"
    
; --------------------------------------------------------------------
BANK $F
BASE $C000

; jump by table
FROM $E814
jump_by_table: