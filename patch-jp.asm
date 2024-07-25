; must be built using build.sh

include "pre.asm"

include "ram-jp.asm"
include "offsets-jp.asm"

VSP_CONTROL_ZERO_VSPEED=$1C

; --------------------------------------------------------------------
BANK $E
BASE $8000

FROM $81FE
getting_hit:

FROM $8307
knockback_step:

FROM $8AC6
standard_state_0:


FROM $952D
standard_idle:

FROM $9624
standard_begin_jump:

FROM $9667
standard_walk:

include "_hooks.asm"

; custom code
FROM empty_bank_e
    LDA #$01
    STA hspint,X
custom_jump_then_standard_jump:
    ; push return address (-1)
    LDA #>standard_jump
    PHA
    LDA #<standard_jump-1
    PHA
custom_jump_jsr:
    include "_custom_jump.asm"

jumping_attack:
    JSR custom_jump_jsr
    JMP attack_resolve ; .. not necessarily air-attacking?

stair_jumping:
    ; pressed jump button?
    LDA joypad_pressed
    AND #$80 ; (pressed jump)
    
    BEQ __recover_step
    
    ; perform jump
    LDA #$06 ; begin jump
    STA simon_state
    
    ; double-return
    ; (quit out of stair logic as well)
    PLA
    PLA
    RTS
    
__recover_step:
    ; here we perform the detour logic to resume a standard tick
    ; however, we must do different logic depending on state/call site

    LDA simon_state
    CMP #$14 ; stair walk
    BEQ __recover_stair_walk
__recover_stair_idle:
    LDA joypad_down
    AND #$40
    RTS
__recover_stair_walk:
    JMP stair_walk_resume

custom_knockback:
    include "_custom_knockback.asm"

crouch_direction:
    LDA joypad_down
    LSR A
    BCC +
    LDX #$00
    STX facing
+
    LSR A
    BCC +
    LDX #$01
    STX facing
+
    ; (detour trampoline continue)
    JMP crouch_resolve
    
LIMIT $C000
    
; --------------------------------------------------------------------
BANK $F
BASE $C000

; jump by table
FROM $E814