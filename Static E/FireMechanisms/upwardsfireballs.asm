header
lorom

org $00FEC4
autoclean JSL InitSpeed
NOP

freedata
InitSpeed:

	LDA $15
	AND #%00001000
	BEQ NormalAngle

	LDA #$D0
	STA $173D,x
	RTL

NormalAngle:
	LDA #$30
	STA $173D,x
	RTL