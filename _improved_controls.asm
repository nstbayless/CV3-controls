; --------------------------------------------------------------------
BANK $E
BASE $8000

include "_hooks.asm"

; custom code
FROM empty_bank_e

reduce_jump_lag_before_jump:
    jmp setStateJumpIfCanJump
_j_to_apply_horizontal_motion
    jmp apply_horizontal_motion

reduce_jump_lag:
    sta simon_state
    bne _j_to_apply_horizontal_motion ; guaranteed

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
    JMP crouch_resolve
  
custom_knockback:
    BANKSWAP CUSTOM_JUMP_BANK
custom_knockback_bankswap_loc:
    rts
    
custom_jump_then_standard_jump:
    ; push return address (-1)
    LDA #>standard_jump
    PHA
    LDA #<standard_jump-1
    PHA
custom_jump_jsr:
    BANKSWAP CUSTOM_JUMP_BANK
custom_jump_bankswap_loc:
    rts

jumping_attack:
    JSR custom_jump_jsr
    JMP attack_resolve ; .. not necessarily air-attacking?
    
LIMIT $C000

; --------------------------------------------------------------------
BANK CUSTOM_JUMP_BANK
BASE $8000

FROM empty_bank_jump
    include "_custom_jump.asm"
    include "_custom_knockback.asm"
end_bank_0_core:
    
FROM custom_knockback_bankswap_loc-5
ATLEAST end_bank_0_core
custom_knockback_bankswap_loc_pre:
    BANKSWAP PLAYER_UPDATE_BANK
    
    ; (bankswap)
    EXACT custom_knockback_bankswap_loc
    
    jsr _custom_knockback
    jmp custom_knockback_bankswap_loc_pre
end_custom_knockback_bankswap_tramp
    
FROM custom_jump_bankswap_loc-5
ATLEAST end_custom_knockback_bankswap_tramp
custom_jump_bankswap_loc_pre:
    BANKSWAP PLAYER_UPDATE_BANK
    
    ; (bankswap)
    EXACT custom_jump_bankswap_loc
    
    jsr _custom_jump
    jmp custom_jump_bankswap_loc_pre
end_custom_jump_bankswap_tramp: