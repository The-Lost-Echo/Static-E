@xkas
HEADER
LOROM

ORG $00D630
JML Main

!Freespace = $208000		;POINT THIS TO SOME FREE SPACE!!!!!! AAAAAAAA

; =======================================
;  CODE FOR U-JUMP GOES HERE
; =======================================

!UYspeed = $90			;Y speed when doing somersault
!UXspeedright = $01		;X speed when doing somersault to left
!UXspeedleft = $FE		;same except right
!UJumpSFX = $02			;Jumping SFX
!USFXPanel = $1DF9		;SFX panel
!UNeededvelocity = $1E		;Minimum required speed to do a U-jump

ORG !Freespace

db "RATS"			;\
dw codeend-codemain-$01		; |Prepare RATS tag.
dw codeend-codemain-$01^#$FFFF	;/ (Yes, Xkas also accepts #$FFFF)

codemain:
Main:			LDA $13E0		;\
			CMP #$0D		; |Essential check.
			BNE Widejump		;/ If the animation is not $0D, go check if it is widejump
			LDA $13E4		;\
			CMP #!UNeededvelocity	; |Check velocity.
			BCC Return		;/ If low, go to normal jumping routine. Else, do next stuff


			LDA #!UXspeedright	;Speed to the right
			LDY $76
			BNE rightstore
			LDA #!UXspeedleft	;speed to the left
rightstore:		STA $7B

			LDA #!UYspeed		;\Set Y-speed
			STA $7D			;/

			LDA #!UJumpSFX		;\
			STA !USFXPanel		;/Jumping sound effect
			JSL $01AB9E		;Show "Contact" GFX
			
			;DEC $13E4		;Make sure you cant run full speed after you land.

finish:			JML $00D668		;Finish u-jump routine

; =======================================
;  CODE FOR LONGJUMP GOES HERE
; =======================================

!LYspeed = $D7			;Y speed when doing somersault
!LXspeedright = $4A		;X speed when doing somersault to left
!LXspeedleft = $B5		;same except right
!LJumpSFX = $08			;Jumping SFX
!LSFXPanel = $1DFC		;SFX panel
!LNeededvelocity = $25		;Minimum required speed to do a U-jump

Widejump:		LDA $187A	;comment out these 2 instructions
			BNE Return	;and you can longjump with yoshi

			LDA $73			;\If not ducking
			BEQ Return		;/return

			LDA $13E4		;\
			CMP #!LNeededvelocity	; |Make sure you have enough speed
			BCC Return		;/

			LDA #!LJumpSFX		;\
			STA !LSFXPanel		;/Play sound effect

			LDA #!LYspeed		;\
			STA $7D			;/Set Y Speed

			LDA #!LXspeedright	;Speed to the right
			LDY $76
			BNE rightwide
			LDA #!LXspeedleft	;speed to the left
rightwide:		STA $7B
			JML $00D668		;Finish widejump routine

; =======================================
;  RECOVER ORIGINAL ROUTINE
; =======================================

Return:			LDA $7B			;\
			BPL go_D637		; |Handle normal jumping
	 		JML $00D634		; |
go_D637:		JML $00D637		;/
codeend: