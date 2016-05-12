;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Wall Kick
;
; Allows Mario to perform a wall kick by sliding along a wall and pressing the
; B button.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

!require_powerup	= !true	; Whether or not wall jumping requires a powerup.

!kick_x_speed		= $1B		; The wall kick X speed.
!kick_y_speed		= $C0		; The wall kick Y speed.
!no_back_time		= $08		; The time to disable moving back after a wall kick.
!slide_accel		= $08		; The sliding acceleration.
!slide_speed		= $24		; The sliding speed.

!flags			= $61		; The wallkick flags. (RAM)
!no_back_timer		= $62		; The timer for not moving back. (RAM)
!temp_y_spd		= $63		; The temporary Y speed. (RAM)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

!false			= 0		; Don't change these.
!true			= 1

org $00A2AF
		autoclean JSL wall_kick
		NOP
		NOP
		
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

freecode
reset bytes

smoke_x_offsets:
		db $0C,$FE

wall_kick_x_speeds:
		db !kick_x_speed^$FF+1,!kick_x_speed

wall_kick:	STZ $1888
		STZ $1889
		
		LDA $77
		AND #$04
		BEQ .in_air
		
		STZ !flags
		RTL
		
	.in_air	LDA !flags
		AND #$03
		BNE .slide
		
		LDA !no_back_timer
		BEQ +
		
		DEC !no_back_timer
		LDA !flags
		LSR
		LSR
		TRB $15
		TRB $16
		
	+	LDA $7D
		BMI .return	
if !require_powerup
		LDA $19
		BEQ .return
endif	
		LDA $71
		ORA $73
		ORA $74
		ORA $75
		ORA $1407
		ORA $140D
		ORA $1470
		ORA $1493
		ORA $187A
		BNE .return
		LDA $7E
		CMP #$09
		BCC .return
		CMP #$E8
		BCS .return
		LDA !flags
		LSR
		LSR
		AND $77
		BNE .return
		LDA $15
		AND #$03
		CMP #$03
		BEQ .return
		LDA $15
		AND $77
		BEQ .return
		
		STA !flags
		LDA $7D
		STA !temp_y_spd
	.return	RTL

	.stop	STZ !flags
		RTL
	
	.slide	LDA $71
		ORA $75
		ORA $1470
		ORA $187A
		BNE .stop
		LDA $7B
		CLC
		ADC #$07
		CMP #$0F
		BCS .stop
		LDA $15
		AND #$03
		CMP #$03
		BEQ .stop
		LDA $15
		AND !flags
		BEQ .stop
		
		LDA #$40
		TRB $15
		TRB $16
		
		LDA !flags
		DEC
		STA $76
		
		LDA $16
		BMI .kick
		
		LDA $14
		AND #$07
		BNE ++
		
		LDX $76
		LDY #$03
	-	LDA $17C0,y
		BNE +
		
		LDA #$03
		STA $17C0,y
		LDA $94
		CLC
		ADC.l smoke_x_offsets,x
		STA $17C8,y
		LDA $96
		CLC
		ADC #$10
		STA $17C4,y
		LDA #$13
		STA $17CC,y
		BRA ++
		
	+	DEY
		BPL -

	++	LDA #$0D
		STA $13E0
		
		LDA !temp_y_spd
		CLC
		ADC #!slide_accel
		STA $7D
		STA !temp_y_spd
		BMI .return
		CMP #!slide_speed
		BCC .return
		LDA #!slide_speed
		STA $7D
		STA !temp_y_spd
		RTL
		
	.kick	LDA #$0B
		STA $72
		LDA #!kick_y_speed
		STA $7D
		LDA #$01
		STA $1406
		STA $1DF9
		STA $1DFA
		
		LDX $76
		LDA.l wall_kick_x_speeds,x
		STA $7B
		
		LDA !flags
		TRB $15
		TRB $16
		ASL
		ASL
		STA !flags
		
		LDA #!no_back_time
		STA !no_back_timer
		
		LDY #$03
	-	LDA $17C0,y
		BNE +
		
		INC
		STA $17C0,y
		LDA $94
		STA $17C8,y
		LDA $96
		CLC
		ADC #$10
		STA $17C4,y
		LDA #$10
		STA $17CC,y
		RTL
		
	+	DEY
		BPL -
		RTL
		
print "Bytes inserted: ", bytes