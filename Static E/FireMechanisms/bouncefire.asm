;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Fireball Bounce Limit
;
; This patch adds a configurable limit to the number of bounces that a fireball
; can take; the fireball will disappear in a puff of smoke after reaching this
; limit. Requires no freespace, but requires 2 bytes of free RAM.
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

header
lorom

!bounces		= $05
!freeram		= $7F8600			; 2 consecutive bytes

org $00FE96
		db $00,$08
		
main:		LDA.l !freeram-8,x
		DEC
		BEQ kill
		STA.l !freeram-8,x

		LDA $1715,x
		SEC
		RTL

org $00FED1
		LDA #!bounces
		STA.l !freeram-8,x
		BRA skip

	kill:	PLA
		PLA
		PLA
		JML $02A4BC
		NOP

	skip:	LDA $94
		CLC
		ADC $FE96,y
		STA $171F,x
		LDA $95
		ADC #$00
		STA $1733,x
		
		LDA $96
		CLC
		ADC #$08
		STA $1715,x
		LDA $97
		ADC #$00
		STA $1729,x
		
		LDA $13F9
		STA $1779,x
		RTS

org $029FFF
		JSL main