_custom_jump:
if CUSTOM_JUMP_BANK == PLAYER_UPDATE_BANK
    jsr rts_if_cutscene
    JSR zero_hspfra
else
    ; return if in cutscene
    lda cutscene_timer
    beq __continue
    lda cutscene_input
    beq __continue
    rts
__continue

    ; zero out fractional hspeed
    lda #$00
    sta hspfra
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