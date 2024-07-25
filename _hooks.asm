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
        ; JSR stair_walk_resume
    JSR stair_jumping

FROM sypha_jumptable

SKIP $8
    ; jump
    DW custom_jump_then_standard_jump

FROM alucard_jumptable
    SKIP $8
    DW custom_jump_then_standard_jump