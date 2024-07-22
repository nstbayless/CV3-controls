; must be built using build.sh

include "pre.asm"

; --------------------------------------------------------------------
BANK $5
BASE $8000

FROM $BF07
    LDY #$00
    STY $0509
    LDA $0520
    BPL LBF12
LBF11:
    RTS
LBF12:
    LDA $2A
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
    STA $0565
    LDX #$0A
    LDA $04A8
    BNE LBF6B
    INX
    INX
LBF6B:
    STX $0400
    LDA #$00
    STA $05EF
    SEC
    SBC $0438
    SEC
    SBC $53
    AND #$0F
    BNE LBF81
    CLC
    ADC #$10
LBF81:
    STA $0B
    LDA $041C
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
    ADC $0B
    STA $041C
    RTS
LBF9A:
    LDA #$12
    STA $0565
    LDX #$0A
    LDA $04A8
    BEQ LBFA8
    INX
    INX
LBFA8:
    STX $0400
    LDA #$01
    STA $05EF
    LDA #$00
    SEC
    SBC $0438
    SEC
    SBC $53
    CLC
    AND #$0F
    STA $0B
    TAX
    LDA $041C
    AND #$F0
    CPX #$00
    CLC
    BEQ LBFCB
    ADC #$10
LBFCB:
    SEC
    SBC $0B
    STA $041C
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
    LDA $041C
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
    STA $08
    LDA $0438
    ADC $53
    AND #$F0
    STA $0B
    LDA $54
    ADC #$00
    STA $0C
    LDA $06
    AND #$01
    BEQ LBFB7
LBF85:
    LDY #$00
LBF87:
    LDA ($66),Y
    CMP #$FF
    BEQ LBFB7
    SEC
    AND #$0F
    CMP $08
    BNE LBFB2
    SEC
    INY
    LDA ($66),Y
    SBC $0B
    BNE LBFB3
    INY
    LDA ($66),Y
    SEC
    SBC $0C
    BNE LBFB4
    DEY
    DEY
    LDA ($66),Y
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
    LDA $08
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
    STA $08
    LDA $0B
    CPX #$C0
    BEQ LBFED
    CPX #$00
    BEQ LBFED
    CLC
    ADC #$10
    STA $0B
    BCC LBFEA
    LDY $0C
    INY
LBFE8:
    STY $0C
LBFEA:
    JMP LBF85
LBFED:
    SEC
    SBC #$10
    STA $0B
    BCS LBFEA
    LDY $0C
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
    STA $0520
    NOP
    LDA #$16
    STA $0400
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
    STA $05D8,X
    LDA #$16
    STA $0400
    LDA #$00
    STA $05C1,X
    STA $0509
    RTS
    LDA $2A
    AND #$03
    RTS
    DB $FF,$FF,$FF,$FF,$FF
    RTS
    LDA $28
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
    STA $04F2,X
    LDA #$97
    PHA
    LDA #$76
    PHA
LBF44:
    JSR $FFDE
    LDY #$00
    LDA $2A
    AND #$03
    BEQ LBFC0
    JSR $9769
    BEQ LBFAA
    LSR A
    BCC LBF5C
    INY
    STY $04F2
    DEY
LBF5C:
    BEQ LBF99
    DEY
    STY $04F2
    LDY #$01
    BPL LBF99
    LDA $4A
    BEQ LBF93
    LDA $0520
    BMI LBF88
    LDA #$08
    STA $0565
    LDA $49
    BEQ LBF8B
    LDA $48
    CMP #$02
    BNE LBF8B
    LDA #$38
    STA $05D8
    LDA #$16
    STA $0400
LBF88:
    JMP LBF93
LBF8B:
    LDA #$1C
    STA $05D8
    LDA $A689,Y
LBF93:
    LDA #$08
    LDY $04F2
    RTS
LBF99:
    LDA $0565
    CMP #$08
    BNE LBFAA
    LDA $0400
    CMP #$10
    BEQ LBFAA
    STY $04A8
LBFAA:
    LDA $2A
    AND #$80
    BNE LBFBF
    LDA $0520
    BPL LBFBF
    LDA #$1C
    STA $05D8
    LDA #$00
    STA $0520
LBFBF:
    RTS
LBFC0:
    STA $04F2
    JMP LBFAA
    JSR LBF44
    JMP $97A3
    LDA $28
    AND #$80
    BEQ LBFDA
    LDA #$06
    STA $0565
    PLA
    PLA
    RTS
LBFDA:
    LDA $0565
    CMP #$14
    BEQ LBFE6
    LDA $2A
    AND #$40
    RTS
LBFE6:
    JMP $9A43
    LDA $2A
    LSR A
    BCC LBFF3
    LDX #$00
    STX $04A8
LBFF3:
    LSR A
    BCC LBFFB
    LDX #$01
    STX $04A8
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
    LDA $0565
    CMP #$12
    BNE LFFEC
    PLA
    PLA
    PLA
    PLA
LFFEC:
    RTS