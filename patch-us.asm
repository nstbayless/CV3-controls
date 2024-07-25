; must be built using build.sh

include "pre.asm"

include "ram-us.asm"
include "offsets-us.asm"

VSP_CONTROL_ZERO_VSPEED=$1C

; --------------------------------------------------------------------
BANK $E
BASE $8000

FROM $81FE
getting_hit:

FROM $8307
knockback_step:

FROM detour_to_custom_knockback
    ; replacement:
        ; lda #$08
        ; ldy $04F2
    NOP
    NOP
    JSR custom_knockback

; in Trevor state jump table ($9376)
FROM trevor_jump_table
SKIP $8
    ; state 8 (jumping)
    ; jump replacement
    DW custom_jump_then_standard_jump

FROM attack
    jsr jumping_attack

FROM jump_attack_step
    jsr jumping_attack

FROM set_fall_state
    ; go to jump state (instead of falling state)
    lda #$08

FROM fall_adjust
    ; x=0 before this
    lda #VSP_CONTROL_ZERO_VSPEED
    STA vsp_control,X
    STX simon_fall_objphase
    lda #$16
    sta imgsin
zero_hspfra:
    lda #$00
    sta hspfra
__standard_rts:
    rts
rts_if_cutscene:
    lda cutscene_timer
    beq __standard_rts
    lda cutscene_input
    beq __standard_rts
    ; double-rts -- rts caller
    pla
    pla
    rts
LIMIT standard_jump

FROM standard_crouch
    jsr crouch_direction

FROM standard_stair_idle
    ; replaces:
        ; LDA joypad_down
        ; AND #$40 ; down ?
    JSR stair_jumping
    NOP
    
FROM standard_stair_walk
    ; replaces:
        ; JSR $9A43
    JSR stair_jumping

FROM sypha_jumptable

SKIP $8
    ; jump
    DW custom_jump_then_standard_jump

FROM alucard_jumptable
    SKIP $8
    DW custom_jump_then_standard_jump

; custom code
FROM empty_bank_e

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
    ; resolve detour: trampoline
    JMP $840C
  
custom_knockback:
    lda #((CUSTOM_JUMP_BANK << 1) | $80)
    jsr setAndSaveLowerBank
custom_knockback_bankswap_loc:
    rts
    
custom_jump_then_standard_jump:
    ; push return address (-1)
    LDA #>standard_jump
    PHA
    LDA #<standard_jump-1
    PHA
custom_jump_jsr:
    ; not sure why we | #$80 but it seems everything else does
    lda #((CUSTOM_JUMP_BANK << 1) | $80)
    jsr setAndSaveLowerBank
custom_jump_bankswap_loc:
    rts

jumping_attack:
    JSR custom_jump_jsr
    JMP $97A3 ; .. not necessarily air-attacking?
    
LIMIT $C000

; --------------------------------------------------------------------
BANK $0
BASE $8000

FROM empty_bank_0
    include "_custom_jump.asm"
    include "_custom_knockback.asm"
end_bank_0_core:
    
FROM custom_knockback_bankswap_loc-5
ATLEAST end_bank_0_core
custom_knockback_bankswap_loc_pre:
    lda #((PLAYER_UPDATE_BANK << 1) | $80)
    jsr setAndSaveLowerBank
    
    ; (bankswap)
    EXACT custom_knockback_bankswap_loc
    
    jsr _custom_knockback
    jmp custom_knockback_bankswap_loc_pre
end_custom_knockback_bankswap_tramp
    
FROM custom_jump_bankswap_loc-5
ATLEAST end_custom_knockback_bankswap_tramp
custom_jump_bankswap_loc_pre:
    lda #((PLAYER_UPDATE_BANK << 1) | $80)
    jsr setAndSaveLowerBank
    
    ; (bankswap)
    EXACT custom_jump_bankswap_loc
    
    jsr _custom_jump
    jmp custom_jump_bankswap_loc_pre
end_custom_jump_bankswap_tramp:
    
; --------------------------------------------------------------------
BANK $F
BASE $C000

; jump by table
FROM $E814