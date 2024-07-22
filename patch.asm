; must be built using build.sh

include "pre.asm"

include "ram.asm"

; --------------------------------------------------------------------
BANK $E
BASE $8000

FROM $8338
    NOP
    NOP
    JSR $BF66

FROM $937E
    DW $BF3E
    
FROM $9430
    DW $BFC6

FROM $94CA
    DW $BFC6

FROM $9750
    DB $08

FROM $9757
    DB $1C
    STA vsp_control,X
    LDA #$00
    STA $5C1,X
    lda #$16
    sta imgsin
    lda #$00
    sta hspfra
    rts
    DB $FF,$FF,$FF,$FF,$FF,$60,$FF,$FF,$FF,$FF,$FF,$FF
    
FROM $9921
    DB $E9,$BF

FROM $99A4
    JSR $BFCC
    NOP
    
FROM $9AAC
    DW $BFCC

FROM $9C21
    DW $BF3E

FROM $A5A3
    DW $BF3E

FROM $BF39
    LDA #$01
    STA hspint,X
custom_jump:
    LDA #$97
    PHA
    LDA #$76
    PHA
LBF44:
    JSR $9765
    LDA $2A
    AND #$03
    BEQ $BFC0
    LSR A
    BCC LBF5C
    LDY #$00
    LDX #$01
    STX hspint
    BPL $BF99
    LSR A
    BCC $BFAA
LBF5C
    LDY #$01
    LDX #$FF
    STX hspint
    JMP $BF99
custom_knockback:
    LDA $4A
    BEQ __return_to_knockback
    LDA vspint
    BMI LBF88
    LDA #tmp_y
    STA simon_state
    LDA $49
    BEQ LBF8B
    LDA $48
    CMP #$02
    BNE LBF8B
    LDA #$38
    STA vsp_control
    LDA #$16
    STA imgsin
LBF88:
    JMP __return_to_knockback
LBF8B:
    LDA #$1C
    STA vsp_control
    LDA $A689,Y
__return_to_knockback:
    LDA #tmp_y
    LDY hspint
    RTS
__jumping_contd:
    LDA simon_state
    CMP #tmp_y
    BNE check_vstall
    LDA imgsin
    CMP #$10
    BEQ check_vstall
    STY facing
check_vstall:
    LDA control_held
    AND #$80
    BNE LBFBF
    LDA vspint
    BPL LBFBF
    LDA #$1C
    STA vsp_control
    LDA #$00
    STA vspint
LBFBF:
    RTS
hstall:
    STA hspint
    JMP check_vstall
jumping_attack:
    JSR LBF44
    JMP $97A3
stair_jumping:
    LDA control_pressed
    AND #$80
    BEQ __recover_step
    LDA #$06
    STA simon_state
    PLA
    PLA
    RTS
__recover_step:
    LDA simon_state
    CMP #$14
    BEQ LBFE6
    LDA control_held
    AND #$40
    RTS
LBFE6:
    JMP $9A43
crouch_direction:
    LDA control_held
    LSR A
    BCC LBFF3
    LDX #$00
    STX facing
LBFF3:
    LSR A
    BCC LBFFB
    LDX #$01
    STX facing
LBFFB:
    JMP $840C