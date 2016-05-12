header
lorom

org $01C5A7
JSL Capedit

org $0FDEAA
Capedit:
LDA #$01
STA $140D
LDA #$18
STA $14A6
LDA #$0C
STA $1DF9
LDA #$04
JSL $01C5AE
RTL

org $01c5F3
JSL Firedit

org $0FDF77
Firedit:
LDA #$17
STA $1DFC
LDA #$04
STA $71
LDA #$10
STA $149B
LDA #$01
STA $140D

LDA $77	
CMP #$04
BNE End
	
LDA #$A8
STA $7D
BRA End

End:
LDA #$10
STA $1497
LDA #$18
STA $14A6
RTL 