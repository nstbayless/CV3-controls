; must be built using build.sh

include "pre.asm"

include "ram.asm"

; --------------------------------------------------------------------
BANK $5
BASE $8000

FROM $BF07
    LDY #$00
    STY hspfra
    LDA vspint
    BPL LBF12
LBF11:
    RTS
LBF12:
    LDA control_held
    AND #$04
    BNE LBF11
    LDX #$10
    LDA #$00
    JSR $FCDE
    BNE LBF11
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    LDX #$00
LBF2A:
    TXA
    PHA
    JSR After_Table_FB44
    PLA
    BCC LBF38
    CMP #$02
    BPL LBF9A
    BMI LBF5D
LBF38:
    NOP
    TAX
    INX
    CPX #$04
    BMI LBF2A
    RTS

Table_BF40:
    DB $00,$80,$C0,$40
Table_BF44:
    DB $80,$00,$40,$C0

After_Table_FB44
    LDA Table_BF40,X
    STA $11
    LDA Table_BF44,X
    STA $12
    STX $06
    LDX #$BF
    LDY #$58
    LDA #$07
    JMP $FFCA
LBF5D:
    LDA #$12
    STA simon_state
    LDX #$0A
    LDA facing
    BNE LBF6B
    INX
    INX
LBF6B:
    STX imgsin
    LDA #$00
    STA stair_direction
    SEC
    SBC xint
    SEC
    SBC view_pix
    AND #$0F
    BNE LBF81
    CLC
    ADC #$10
LBF81:
    STA tmp_x
    LDA yint
    TAX
    AND #$0F
    BNE LBF90
    TXA
    SEC
    SBC #$10
    TAX
LBF90:
    TXA
    AND #$F0
    CLC
    ADC tmp_x
    STA yint
    RTS
LBF9A:
    LDA #$12
    STA simon_state
    LDX #$0A
    LDA facing
    BEQ LBFA8
    INX
    INX
LBFA8:
    STX imgsin
    LDA #$01
    STA stair_direction
    LDA #$00
    SEC
    SBC xint
    SEC
    SBC view_pix
    CLC
    AND #$0F
    STA tmp_x
    TAX
    LDA yint
    AND #$F0
    CPX #$00
    CLC
    BEQ LBFCB
    ADC #$10
LBFCB:
    SEC
    SBC tmp_x
    STA yint
    RTS

; --------------------------------------------------------------------
BANK $7
BASE $8000

FROM $BF55
LBF55:
    CLC
    RTS
LBF57:
    SEC
    RTS
    LDX $06
    LDA yint
    CPX #$02
    CLC
    BMI LBF65
    SBC #$10
LBF65:
    ADC #$0F
    LSR A
    LSR A
    LSR A
    LSR A
    NOP
    NOP
    CLC
    STA tmp_y
    LDA xint
    ADC view_pix
    AND #$F0
    STA tmp_x
    LDA view_subroom
    ADC #$00
    STA tmp_xscreen
    LDA $06
    AND #$01
    BEQ LBFB7
LBF85:
    LDY #$00
LBF87:
    LDA (stairs),Y
    CMP #$FF
    BEQ LBFB7
    SEC
    AND #$0F
    CMP tmp_y
    BNE LBFB2
    SEC
    INY
    LDA (stairs),Y
    SBC tmp_x
    BNE LBFB3
    INY
    LDA (stairs),Y
    SEC
    SBC tmp_xscreen
    BNE LBFB4
    DEY
    DEY
    LDA (stairs),Y
    AND #$F0
    CMP $11
    BEQ LBF55
    CMP $12
    BEQ LBF57
LBFB2:
    INY
LBFB3:
    INY
LBFB4:
    INY
    BPL LBF87
LBFB7:
    LDX $12
    LDA tmp_y
    CPX #$40
    BEQ LBFCA
    CPX #$00
    BEQ LBFCA
    SEC
    SBC #$01
    BCC LBF55
    BCS LBFD2
LBFCA:
    CLC
    ADC #$01
    NOP
    CMP #$0F
    BPL LBF55
LBFD2:
    STA tmp_y
    LDA tmp_x
    CPX #$C0
    BEQ LBFED
    CPX #$00
    BEQ LBFED
    CLC
    ADC #$10
    STA tmp_x
    BCC LBFEA
    LDY tmp_xscreen
    INY
LBFE8:
    STY tmp_xscreen
LBFEA:
    JMP LBF85
LBFED:
    SEC
    SBC #$10
    STA tmp_x
    BCS LBFEA
    LDY tmp_xscreen
    DEY
    JMP LBFE8

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
    
FROM $95F1
    DB $D0,$04
    NOP
    NOP
    
FROM $9629
    LDA #$FF
    STA vspint
    NOP
    LDA #$16
    STA imgsin
    LDA #$00
    STA $05C1
    LDA #$09
    DB $8D
    
FROM $9645
    DB $2A

FROM $964D
    DB $8D
    
FROM $9658
    DB $8D

FROM $9750
    DB $08

FROM $9757
    DB $1C
    STA vsp_control,X
    LDA #$16
    STA imgsin
    LDA #$00
    STA $05C1,X
    STA hspfra
    RTS
    LDA control_held
    AND #$03
    RTS
    DB $FF,$FF,$FF,$FF,$FF
    RTS
    LDA control_pressed
    RTS

FROM $97A7
    DB $CE
    
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
    LDA #$97
    PHA
    LDA #$76
    PHA
LBF44:
    JSR $FFDE
    LDY #$00
    LDA control_held
    AND #$03
    BEQ LBFC0
    JSR $9769
    BEQ LBFAA
    LSR A
    BCC LBF5C
    INY
    STY hspint
    DEY
LBF5C:
    BEQ LBF99
    DEY
    STY hspint
    LDY #$01
    BPL LBF99
    LDA $4A
    BEQ LBF93
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
    JMP LBF93
LBF8B:
    LDA #$1C
    STA vsp_control
    LDA $A689,Y
LBF93:
    LDA #tmp_y
    LDY hspint
    RTS
LBF99:
    LDA simon_state
    CMP #tmp_y
    BNE LBFAA
    LDA imgsin
    CMP #$10
    BEQ LBFAA
    STY facing
LBFAA:
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
LBFC0:
    STA hspint
    JMP LBFAA
    JSR LBF44
    JMP $97A3
    LDA control_pressed
    AND #$80
    BEQ LBFDA
    LDA #$06
    STA simon_state
    PLA
    PLA
    RTS
LBFDA:
    LDA simon_state
    CMP #$14
    BEQ LBFE6
    LDA control_held
    AND #$40
    RTS
LBFE6:
    JMP $9A43
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

; --------------------------------------------------------------------
BANK $F
BASE $C000

FROM $FFC4
LFFC4:    
    LDA #$05
    LDX #$BF
    LDY #$06
    STA $05
    LDA $23
    PHA
    LDA #$FF
    PHA
    LDA #$A5
    PHA
    TXA
    PHA
    TYA
    PHA
    LDA $05
    JMP $E2D0
    JSR LFFC4
    LDA simon_state
    CMP #$12
    BNE LFFEC
    PLA
    PLA
    PLA
    PLA
LFFEC:
    RTS