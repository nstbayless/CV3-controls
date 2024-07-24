; must be built using build.sh

include "pre.asm"

include "ram.asm"

VSP_CONTROL_ZERO_VSPEED=$1C

; --------------------------------------------------------------------
BANK $E
BASE $8000

FROM $81FE
getting_hit:

FROM $8307
knockback_step:

FROM $8338
    NOP
    NOP
    JSR custom_knockback

FROM $8AC6
standard_state_0:

; in Trevor state jump table ($9376)
FROM $9376
trevor_jump_table:

FROM $937E
    ; state 8 (jumping)
    ; jump replacement
    DW custom_jump_then_standard_jump

FROM $942F
attack:
    jsr jumping_attack

FROM $94C9
jump_attack_step:
    jsr jumping_attack

FROM $952D
standard_idle:

FROM $9624
standard_begin_jump:

FROM $9667
standard_walk:

FROM $974F
    ; go to jump state (instead of falling state)
    lda #$08

FROM $9756
    ; x=0 before this
    lda #VSP_CONTROL_ZERO_VSPEED
    STA vsp_control,X
    LDA #$00
    STA simon_fall_objphase,X
    lda #$16
    sta imgsin
zero_hspfra:
    lda #$00
    sta hspfra
    rts
    ;DB $FF,$FF,$FF,$FF,$FF,$60,$FF,$FF,$FF,$FF,$FF,$FF

FROM $9777
standard_jump:

FROM $9920
standard_crouch:
    jsr crouch_direction

FROM $99A4
standard_stair_idle:
    ; replaces:
        ; LDA joypad_down
        ; AND #$40 ; down ?
    JSR stair_jumping
    NOP
    
FROM $9AAB
standard_stair_walk:
    ; replaces:
        ; JSR $9A43
    JSR stair_jumping

FROM $9C19
sypha_jumptable:

FROM $9C21
    DW custom_jump_then_standard_jump

FROM $A59B
alucard_jumptable:

FROM $A5A3
    DW custom_jump_then_standard_jump

; custom code
FROM $BF39
    LDA #$01
    STA hspint,X
custom_jump_then_standard_jump:
    ; push return address (-1)
    LDA #$97
    PHA
    LDA #$76
    PHA
custom_jump_jsr:
    JSR zero_hspfra
    LDA joypad_down
    AND #$03 ; 1=right, 2=left
    BEQ hcancel
    LSR A
    BCC air_control_left
    
air_control_right:
    ; if left and right, hcancel
    LSR A
    BCS hcancel
    
    ; standard right
    LDY #$00
    LDX #$01
    STX hspint
    BPL __jumping_contd ; guaranteed
air_control_left:
    LDY #$01
    LDX #$FF
    STX hspint
__jumping_contd

    ; decide whether or not to set facing
    LDA simon_state
    CMP #8 ; jumping
    BNE check_vcancel
    LDA imgsin
    CMP #$10
    
set_facing:
    BEQ check_vcancel
    STY facing
    BNE check_vcancel ; guaranteed
    
hcancel:
    STA hspint
    
check_vcancel:
    LDA joypad_down
    AND #$80 ; holding jump button?
    BNE __vcancel_rts
    LDA vspint ; already moving downward?
    BPL __vcancel_rts
    
    LDA #VSP_CONTROL_ZERO_VSPEED
    STA vsp_control
    LDA #$00
    STA vspint
__vcancel_rts:
    RTS

jumping_attack:
    JSR custom_jump_jsr
    JMP $97A3 ; .. not necessarily air-attacking?

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
    JMP $9A43

custom_knockback:
    ; if 0 hp, do normal knockback
    LDA hitpoints
    BEQ __return_to_knockback
    
    LDA vspint
    BMI custom_knockback_moving_upward
    
    LDA #8 ; jumping
    STA simon_state
    LDA $49
    BEQ custom_knockback_moving_upward
    LDA $48
    CMP #$02
    BNE custom_knockback_moving_upward
    LDA #$38
    STA vsp_control
    LDA #$16
    STA imgsin
    JMP __return_to_knockback
    
custom_knockback_moving_upward:
    LDA #VSP_CONTROL_ZERO_VSPEED
    STA vsp_control
    LDA $A689,Y
__return_to_knockback:
    LDA #8
    LDY hspint
    RTS

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
    JMP $840C
    
; --------------------------------------------------------------------
BANK $F
BASE $C000

; jump by table
FROM $E814