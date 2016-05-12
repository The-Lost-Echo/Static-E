@xkas
header
lorom

!Freeram 	= 	$0DDB	                ;\	CHANGE THIS!!!!!
!Freeram2	=	$0DDC			; |	CHANGE THIS AS WELL!!!
!Freespace 	= 	$20817B			;/	CHANGE THIS TOO!!!!!

!Freezetime	=	$08			;\	change this to change the amount of time the player stays in the air before ground pounding.
!Pose		=	$1C			; |	this is the pose that the player will have when ground pounding.
!SFX1		=	$23			; |	the sound effect that plays right before ground pounding
!SFX2		=	$08			; |	the sound effect that plays once the player hits the ground
!SFX1bank	=	$1DF9			; |	the bank of the first sound effect
!SFX2bank	=	$1DF9			;/	the bank of the second sound effect

;----------------------------------------------------------------------------------------------------------------------------
;	DON'T EDIT ANY OF THIS UNLESS YOU KNOW WHAT YOU ARE DOING!
;----------------------------------------------------------------------------------------------------------------------------

org $00A1DA					;\	this is the main part of the code
	NOP					; |	it runs the ground pound code
	JML Hijack				;/	

org $00D948					;\	this kills gravity while the player stays in the air before ground pounding
	JSL KillGravity				;/	to fix the glitch with the layer 3 smashers

org $01AA37					;\	this fixes $01AA33 so that it boosts you up
	JSL BounceHijack			;/

org $01A91C					;\	this makes it so that enemies that are stompable
	NOP #2					; |	will be killed with ground pounds
	JSL Hijack2				;/	

org $01AA42					;\	this code makes it so that carriable enemies
	NOP #2					; |	die to ground pounds
	JSL Hijack2				;/	

org $0395AB					;\	and this fixes the rexes
	NOP #2					; |	so that they will die from ground pounds as other sprites do
	JSL RexHijack				;/	

org $02C7E8					;\	this bit of code forces chucks to take 2 damage from ground pounds
	NOP #2					; |	
	JSL ChuckHijack				;/	

org $01CFC6					;\	this code makes morton/roy/ludwig take 2 damage
	NOP #2					; |	from ground pounds
	JSL KoopaKidHijack			;/	

org $03CE13					;\	this hijack makes lemmy/wendy take 2 damage from ground pounds
	NOP #2					; |	
	JSL KoopaKidHijack2			; |	
	CMP #$03				; |	
	BCC $B2					;/	

org $01D3AB					;\	this hijack marks the boss to have its HP taken down by 2
	NOP					; |	if it was ground pounded
	JSL KKHijack2				;/	

org $03CECB					;\	""
	NOP					; |	""
	JSL KKHijack2				;/	

org !Freespace					;	setting our freespace. we don't want to overwrite stuff past $0395B1

db "STAR"					;\	RATS tag to protect this code from lunar magic
dw HijacksEnd-Hijack-$01			; |	
dw HijacksEnd-Hijack-$01^$FFFF			;/	

Hijack:
	LDA !Freeram				;\	if the ground pound timer is nonzero, skip to the routine
	BNE StartRoutine			;/	

	JSR Checks				;	run all checks,
	BNE End					;	and if it's all good, continue on with the code

	LDA $77					;\	if the player is on the ground,
	AND #$04				;/	then end immediately
	BNE End					;	

	LDA $16					;\	if the player hasn't pressed down,
	AND #$04				;/	(to activate the ground pound obviously)
	BEQ End					;	end immediately

	LDA #!SFX1				;\	play a sound effect
	STA !SFX1bank				; |	(specifically, the big boo boss killed sound effect)
	LDA #!Freezetime			; |	set the ground pound RAM address to a nonzero value != 1
	STA !Freeram				; |	to initiate a timer
	STZ $7B					; |	
	STZ $7D					; |	zero the player's x speed and y speed,
	STZ $14A6				; |	disable cape spins,
	STZ $149F				; |	and takeoff meter
	BRA StartRoutine			;/	and start the ground pound

End:
	LDA $1426
	BEQ +
	JML $00A1DF
+
	JML $00A1E4

StartRoutine:
	JSR Checks				;\	run all checks,
	BEQ .skip				;/	and if it's all good, continue on

.end
	STZ !Freeram				;\	forcibly end the ground pound
	STZ !Freeram2				;/
	BRA End					;	

.skip
	LDA $16					;\	if the player pressed up in 							midair,
	AND #$08				;/	cancel the ground pound
	BNE .end				;	

	STZ $15					;\	disable all controls
	STZ $16					; |	so that the player cannot throw fireballs,
	STZ $17					; |	move the screen,
	;STZ $18					; |	or move in midair
	STZ $140D				;/	disable spin jumping as well

	LDA #!Pose				;\	this makes mario have the correct pose
	STA $13E0				; |	when ground pounding
	LDA !Freeram				; |	if the timer is at #$01,
	CMP #$01				; |	keep the timer from decrementing
	BEQ SkipFreeze				;/	so that the ground pound flag isn't zeroed out

	STZ $7B					;\	zero x speed
	DEC !Freeram				;/	make the timer count down
	BRA End					;	and return

SkipFreeze:
	LDA #$50				;\	make the player fall down,
	STA $7D					; |	and freeze his x speed so he can't move
	STZ $7B					;/	

	LDA $77					;\	if the player has already reached the ground,
	AND #$04				; |	skip forward
	BNE OnGround				;/	
	BRA End					;

OnGround:
	JSR Slide				;\	Make the player slide upon impact
	LDA #!SFX2				; |	this is so that the spin jump kill sound will play,
	STA !SFX2bank				; |	this ends the ground pound,
	STZ !Freeram				; |	and this creates smoke at the bottom of the player's feet
	STZ !Freeram2				; |
	JSR CreateSmoke				;/	
	BRA End					;	return

Checks:
	LDA $73					;\	if the player is ducking,
	ORA $74					; |	or climbing,
	ORA $75					; |	or in water,
	ORA $9D					; |	or if sprites are locked,
	ORA $1407				; |	or flying with a cape
	ORA $1470				; |	or carrying something
	ORA $1493				; |	or if the level is ending,
	ORA $187A				;/	or on yoshi, A (the accumulator) will be nonzero
	RTS					;	return

SlideTable:
	db $00, $F4, $0C, $EC
	db $14, $DC, $24, $00
	db $00, $00, $00, $D4
	db $2C

Slide:
	LDA $13E1				;\	take the kind of slope Mario is on
	LSR #3					; |	and divide it by 8
	TAX					; |
	LDA SlideTable,x			; |	use that value as an index to a speeds table
	STA $7B					; |
	LDA #$1C				; |	make mario slide
	STA $13ED				;/
	RTS					;	return

DATA_00D7A5:
	db $06,$03,$04,$10,$F4,$01,$03,$04
	db $05,$06

KillGravity:
	PHB					;\	change program bank to current bank
	PHK					; |
	PLB					; |
	PHA					; |
	LDA !Freeram				; |	if the timer is >2
	CMP #$02				; |	(Meaning that the player is floating in the air)
	BCS .killgravity			; |	destroy gravity
	PLA					;/
	
	CLC					;\	restore code
	ADC DATA_00D7A5,y			;/
	PLB
	RTL					;	return

.killgravity
	PLA
	PLB
	RTL					;	return and kill gravity!

CreateSmoke:
	LDY #$09				;	setting up the index for the loop here-

.loop
	LDA $170B,y				;\	check for empty slots.
	BEQ .found				; |	if one was found, start the smoke cloud code
	DEY					; |	otherwise, decrease the index by 1
	BPL .loop				;/	and test the adddress again
	RTS					;	if no free slots were found, return

.found
	LDA #$01				;\	set the extended sprite type to a smoke cloud
	STA $170B,y				; |	
	LDA $94					; |	position the cloud at the player's whole x position
	STA $171F,y				; |	
	LDA $95					; |	
	STA $1733,y				; |	
	LDA $96					; |	take the player's y position, and shift it down by a block and a half
	CLC					; |	
	ADC #$18				; |	
	STA $1715,y				; |	
	LDA $97					; |	this code is here to take care of overflow. If by the ADC #$18 the value overflows,
	ADC #$00				; |	the carry flag will be set and will be added alongside the #$00
	STA $1729,y				; |	
	LDA #$0F				; |	this sets the timer that dictates how long the smoke cloud will be there
	STA $176F,y				;/	
	RTS					;	return

Hijack2:
	LDA $140D				;	this makes it so that

Rex1:
	ORA $187A				;\	spin jumps, ground pounds, and yoshi stomps kill enemies that you can jump on
	ORA !Freeram				;/	
	RTL					;	return

RexHijack:
	LDA $140D				;\	fixing rex
	ORA !Freeram2				; |
	BRA Rex1				;/

ChuckHijack:
	INC $1528,x				;\	increase the hit amount normally,
	LDA !Freeram2				; |	
	BEQ .skip				;/	and if the player ground pounded the chuck,

	INC $1528,x				;\	increase the hit amount again (essentially damaging the chuck for two)
	STZ !Freeram2				;/	and end the ground pound

.skip
	LDA $1528,x				;	restore this last bit of code,
	RTL					;	and return

KoopaKidHijack:
	INC $1626,x				;\	increase hit amount normally
	LDA !Freeram2				; |	
	BEQ .skip				;/	if the player ground pounded the boss,

	INC $1626,x				;\	increase hit amount again (essentially damaging the boss for two)
	STZ !Freeram2				;/	and end the ground pound

.skip
	LDA $1626,x				;	restore this last bit of code,
	RTL					;	and return

KoopaKidHijack2:
	INC $1534,x				;\	increase hit amount normally
	LDA !Freeram2				; |	
	BEQ .skip				;/	if the player ground pounded the boss,

	INC $1534,x				;\	increase hit amount again (essentially damaging the boss for two)
	STZ !Freeram2				;/	and end the ground pound

.skip
	LDA $1534,x				;	restore this last bit of code,
	RTL					;	and return

KKHijack2:
	JSL $01AA33				;\	boost mario up
	LDA #$28				; |	play the sound effect code we overwrote
	STA $1DFC				;/	
	RTL					;	and return

BounceHijack:
	LDA !Freeram				;\	take the ground pound flag
	STA !Freeram2				; |	and store it to another flag
	STZ !Freeram				; |	and zero the ground poung flag
	LDA #$D0				; |	restore code!
	BIT $15					;/
	RTL					;	return

HijacksEnd: