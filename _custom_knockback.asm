_custom_knockback:
    ; if 0 hp, do normal knockback
    LDA hitpoints
    BEQ __return_to_knockback
    
    LDA vspint
    BMI custom_knockback_moving_upward
    
    LDA #8 ; jumping
    STA simon_state
    LDA current_player
    cmp #$02 ; grant
    BNE custom_knockback_moving_upward
grant_version:
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
    ; resolve detour
    LDA #8
    LDY hspint
    RTS