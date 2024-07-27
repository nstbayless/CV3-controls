_custom_jump:
if CUSTOM_JUMP_BANK == PLAYER_UPDATE_BANK
    jsr rts_if_cutscene
    if INERTIA != 0
        ERROR INERTIA must be 0 if PLAYER_UPDATE_BANK=E
    endif
    JSR zero_hspfra
else
    ; return if in cutscene
    lda cutscene_timer
    beq __continue
    lda cutscene_input
    beq __continue
    rts
__continue

if INERTIA == 0
    ; zero out fractional hspeed
    lda #$00
    sta hspfra
endif

endif
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
    if INERTIA == 0
        LDX #$01
        STX hspint
    else
        jsr apply_inertia_rightward_full
    endif
    LDY #$00
    BEQ __jumping_contd ; guaranteed
air_control_left:
    if INERTIA == 0
        LDX #$FF
        STX hspint
    else
        jsr apply_inertia_leftward_full
    endif
    LDY #$01
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
if INERTIA == 0
    STA hspint
else

    ; apply positive or negative inertia as necessary
    ; zero out hspfra *if* within INERTIA of #$0
    lda hspint
    bne standard_hcancel:
    ldy #$0
    lda hspfra
    sty hspfra
    cmp #INERTIA
    bcc check_vcancel
    CMP #($100-INERTIA)
    bcs check_vcancel
    sta hspfra
standard_hcancel
    bit hspint
    bmi +
    jsr apply_inertia_leftward_full
    jmp check_vcancel
+   
    jsr apply_inertia_rightward_full
    
endif
    
check_vcancel:
    ifdef VCANCEL
        LDA joypad_down
        AND #$80 ; holding jump button?
        BNE __vcancel_rts
        LDA vspint ; already moving downward?
        BPL __vcancel_rts
        
        LDA #VSP_CONTROL_ZERO_VSPEED
        STA vsp_control
        LDA #$00
        STA vspint
    endif
__vcancel_rts:
    RTS
    
if INERTIA != 0
apply_inertia_rightward_full:
    clc
    lda #INERTIA
    adc hspfra
    sta hspfra
    lda #$0
    adc hspint
    
    ; clamp hspint
    cmp #$01
    bpl __apply_inertia_rts_r
    sta hspint
    rts

__apply_inertia_rts_r
    lda #$01
__apply_inertia_rts
    sta hspint
zero_hspfra_custom_bank:
    lda #$0
    sta hspfra
    rts

apply_inertia_leftward_full:
    sec
    lda hspfra
    sbc #INERTIA
    sta hspfra
    lda hspint
    sbc #0
    cmp #$FF
    bmi __apply_inertia_l_rts
    sta hspint
    rts
    
__apply_inertia_l_rts:
    lda #$FF
    bne __apply_inertia_rts ; guaranteed
endif