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
    DB $18,$60,$38,$60,$A6,$06,$AD,$1C,$04,$E0,$02,$18,$30,$02,$E9,$10
    DB $69,$0F,$4A,$4A,$4A,$4A,$EA,$EA,$18,$85,$08,$AD,$38,$04,$65,$53
    DB $29,$F0,$85,$0B,$A5,$54,$69,$00,$85,$0C,$A5,$06,$29,$01,$F0,$32
    DB $A0,$00,$B1,$66,$C9,$FF,$F0,$2A,$38,$29,$0F,$C5,$08,$D0,$1E,$38
    DB $C8,$B1,$66,$E5,$0B,$D0,$17,$C8,$B1,$66,$38,$E5,$0C,$D0,$10,$88
    DB $88,$B1,$66,$29,$F0,$C5,$11,$F0,$A7,$C5,$12,$F0,$A5,$C8,$C8,$C8
    DB $10,$D0,$A6,$12,$A5,$08,$E0,$40,$F0,$0B,$E0,$00,$F0,$07,$38,$E9
    DB $01,$90,$8D,$B0,$08,$18,$69,$01,$EA,$C9,$0F,$10,$83,$85,$08,$A5
    DB $0B,$E0,$C0,$F0,$13,$E0,$00,$F0,$0F,$18,$69,$10,$85,$0B,$90,$05
    DB $A4,$0C,$C8,$84,$0C,$4C,$85,$BF,$38,$E9,$10,$85,$0B,$B0,$F6,$A4
    DB $0C,$88,$4C,$E8,$BF

; --------------------------------------------------------------------
BANK $E
BASE $8000

FROM $8338
    DB $EA,$EA,$20,$66,$BF

FROM $937E
    DB $3E,$BF
    
FROM $9430
    DB $C6,$BF

FROM $94CA
    DB $C6,$BF
    
FROM $95F1
    DB $D0,$04,$EA,$EA
    
FROM $9629
    DB $A9,$FF,$8D,$20,$05,$EA,$A9,$16,$8D,$00,$04,$A9,$00,$8D,$C1,$05
    DB $A9,$09,$8D
    
FROM $9645
    DB $2A

FROM $964D
    DB $8D
    
FROM $9658
    DB $8D

FROM $9750
    DB $08

FROM $9757
    DB $1C,$9D,$D8,$05,$A9,$16,$8D,$00,$04,$A9,$00,$9D,$C1,$05,$8D,$09
    DB $05,$60,$A5,$2A,$29,$03,$60,$FF,$FF,$FF,$FF,$FF,$60,$A5,$28,$60

FROM $97A7
    DB $CE
    
FROM $9921
    DB $E9,$BF

FROM $99A4
    DB $20,$CC,$BF,$EA
    
FROM $9AAC
    DB $CC,$BF

FROM $9C21
    DB $3E,$BF

FROM $A5A3
    DB $3E,$BF

FROM $BF39
    DB $A9,$01,$9D,$F2,$04,$A9,$97,$48,$A9,$76,$48,$20,$DE,$FF,$A0,$00
    DB $A5,$2A,$29,$03,$F0,$71,$20,$69,$97,$F0,$56,$4A,$90,$05,$C8,$8C
    DB $F2,$04,$88,$F0,$3B,$88,$8C,$F2,$04,$A0,$01,$10,$33,$A5,$4A,$F0
    DB $29,$AD,$20,$05,$30,$19,$A9,$08,$8D,$65,$05,$A5,$49,$F0,$13,$A5
    DB $48,$C9,$02,$D0,$0D,$A9,$38,$8D,$D8,$05,$A9,$16,$8D,$00,$04,$4C
    DB $93,$BF,$A9,$1C,$8D,$D8,$05,$B9,$89,$A6,$A9,$08,$AC,$F2,$04,$60
    DB $AD,$65,$05,$C9,$08,$D0,$0A,$AD,$00,$04,$C9,$10,$F0,$03,$8C,$A8
    DB $04,$A5,$2A,$29,$80,$D0,$0F,$AD,$20,$05,$10,$0A,$A9,$1C,$8D,$D8
    DB $05,$A9,$00,$8D,$20,$05,$60,$8D,$F2,$04,$4C,$AA,$BF,$20,$44,$BF
    DB $4C,$A3,$97,$A5,$28,$29,$80,$F0,$08,$A9,$06,$8D,$65,$05,$68,$68
    DB $60,$AD,$65,$05,$C9,$14,$F0,$05,$A5,$2A,$29,$40,$60,$4C,$43,$9A
    DB $A5,$2A,$4A,$90,$05,$A2,$00,$8E,$A8,$04,$4A,$90,$05,$A2,$01,$8E
    DB $A8,$04,$4C,$0C,$84

; --------------------------------------------------------------------
BANK $F
BASE $C000

FROM $FFC4
    DB $A9,$05,$A2,$BF,$A0,$06,$85,$05,$A5,$23,$48,$A9,$FF,$48,$A9,$A5
    DB $48,$8A,$48,$98,$48,$A5,$05,$4C,$D0,$E2,$20,$C4,$FF,$AD,$65,$05
    DB $C9,$12,$D0,$04,$68,$68,$68,$68,$60
