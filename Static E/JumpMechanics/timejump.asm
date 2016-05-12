@xkas
; SM64 Triple jump
; By: HuFlungDu
; This patch will give you the ability in SM64 where when you  jumped twice in a row, you would go higher
; and if you jump three times in a row while running at full speed you go even higher
; (I can't make Mario flip of course, what do you think this is, SMB3?)
; What's new in this version?:
; Mainly what's new is:
; A) It uses a different way of making you jump higher (changing original speed stored instead of just subtracting from speed, so gravity works too), allowing more than two possibilities.
; B) as an extension of that, now has configurable jumps heights (detailed below).
; I also pretty much just cleaned up the code since it was quite a freaking mess
; Now it should make far more sense.
; It also no longer hijacks NMI
; As always, no credit necessary.



!freeram = $0F5E	; controls which jump to do
!freeram2 = $0F5F						; A timer to check if you've been on the ground long enough for the first RAM to reset
!freeram3 = $0F60
!JumpyHeight1 = $C0			;\ Speeds given to Mario upon jumping
!JumpyHeight2 = $B0			;| The lower the value (down to 80), the higher the jump.
!JumpyHeight3 = $90			;/


macro RATS_start(id)
db "STAR"
dw RATS_Endcode<id>-RATS_Startcode<id> 
dw RATS_Endcode<id>-RATS_Startcode<id>^#$FFFF 
RATS_Startcode<id>: 
endmacro

macro RATS_end(id)
RATS_Endcode<id>: 
endmacro

lorom                   ;\ ROM is LoRom
header                  ;/ and has a header.

org $D663
JSL JumpyCode
NOP

;org $8DC4               ;Un comment this if you've already applied the old version.
;LDA #$02                
;STA $420B

org $8E1A
JSL SetupCode
NOP

ORG $208068                    ;| POINT TO FREE SPACE!!!
%RATS_start(0)

SetupCode:
		LDA $77			;\Check if your already in the air
		AND #$04
		BEQ JumpReturn
		LDA !freeram	;\ Basically, if you are on your last jump, but stop going fast enough
		CMP #$02		;| This won't let you do the highest jump.
		BNE Running		;|
		LDA $7B			;|
		CMP #$CD		;|
		BCS NotRunning2	;|
		CMP #$29		;|
		BCC NotRunning2
	;/
		Running:
		LDA !freeram	;\ Check which jump to do
		BEQ FirstJump	;| 
		CMP #$01		;|
		BEQ SecondJump	;|
		CMP #$02		;|
		BEQ ThirdJump	;/
		JMP Return
				; While this isn't actually possible (to the best of my knowledge), I put it here just in case...
		NotRunning2:	;\
		STZ !freeram	;| No special jumping
		STZ !freeram3	;|
		JMP Running		;/
		
		
		FirstJump:		; If you are on your first jump
		LDA !freeram	;\ check if you just jumped your third
		CMP #$02		;| and reset if you did
		BNE Jumpone		;|
		STZ !freeram	;/
		STZ !freeram3
		Jumpone:
		LDA $16         ;\ check if B is pressed
		AND #$80        ;|
		BEQ Return      ;/ if not, return

		;LDA #$24	;MY POSE ADD-ON
		;STA $72		;
		LDA #$00		;\ Reset the Timer
		STA !freeram2		;/ 
		LDA #$01		;\Ready the next jump
		STA !freeram		;/
		STZ !freeram3
		JMP Return		; and return
		
	
		SecondJump:
		LDA $16         ;\ check if B is pressed
		AND #$80        ;|
		BEQ JumpReturn      ;/ if not, return
		LDA #$02		;\ Ready the third jump
		STA !freeram	;/
		LDA #$01
		STA !freeram3
		JMP Return		; and return
		
		
		NotRunning:
		STZ !freeram	;\If you aren't running
		STZ !freeram3	;|clear the RAMs
						;/(this is used farther down...)
		JumpReturn:
		JMP Return
		
		
		ThirdJump:
		LDA $16         ;\ check if B is pressed
		AND #$80        ;|
		BEQ Return      ;/ if not, return
		LDA $7B			;\If running...
		CMP #$CD		;|
		BCS NotRunning	;|
		CMP #$29		;|
		BCC NotRunning	;/
		STZ !freeram	;\Then set jump RAM and zero out counter
		LDA #$02		;|
		STA !freeram3	;/
		
		
		Return:
		LDA $77			;\Check if your already in the air
		AND #$04		;|
		BEQ DontIncRAM	;/ If you are, Reset the Timer RAM and don't increase it any more
		INC !freeram2	;\Increase the Timer
		BRA DontIncRAM2 ;/ Note, the name is left over from a previous attempt.
		DontIncRAM:		
		STZ !freeram2	; Reset the timer
		DontIncRAM2:
		LDA !freeram2	;\Check if the timer is > 10
		CMP #$10		;|
		BCC notstore	;/
		STZ !freeram	;\If it is, reset all the RAM addresses
		STZ !freeram2	;|
		STZ !freeram3	;/
		notstore:
		Ret:
		LDA $1493       ; \Yada Yada restore code  
		ORA $9D     	; /
		RTL				; And finally, return
		
		
		JumpyCode:
		PHB				;\Get in the right bank
		PHK				;|(you probably recognize this from most sprites)
		PLB				;/
		LDA $140D		 ;\If you spin jump, just do regular height
		BNE ItsASpinJump ;/(Comment out these two lines if you don't like that idea)
		PHX
		LDA !freeram3		;\Get pointer to which table we want to grab from
		ASL					;|
		TAX					;|
		REP #$20			;|
		LDA JumpyPointers,x	;|
		STA $05				;|And store it to scratch RAM
		SEP #$20			;/
		PLX
		PHY					;\load from the table we decided on earlier
		TXY					;|(Pointer loads have to be indexed by Y, not X)
		LDA ($05),y			;|
		PLY					;|
		STA $7D				;/
		PLB					;Get back to the right bank
		RTL					;Return
		ItsASpinJump:		;\Just load regular heights
		LDA Jumpy1,x		;|
		STA $7D				;/
		PLB					;Get back to the right bank
		RTL					;Return
		
		
		
		Jumpy1:
		db !JumpyHeight1,!JumpyHeight1+6,!JumpyHeight1-2,!JumpyHeight1+4,!JumpyHeight1-5
		db !JumpyHeight1+2,!JumpyHeight1-7,!JumpyHeight1,!JumpyHeight1-10,!JumpyHeight1-2
		db !JumpyHeight1-12,!JumpyHeight1-15,!JumpyHeight1-7,!JumpyHeight1-17,!JumpyHeight1-10
		Jumpy2:
		db !JumpyHeight2,!JumpyHeight2+6,!JumpyHeight2-2,!JumpyHeight2+4,!JumpyHeight2-5
		db !JumpyHeight2+2,!JumpyHeight2-7,!JumpyHeight2,!JumpyHeight2-10,!JumpyHeight2-2
		db !JumpyHeight2-12,!JumpyHeight2-15,!JumpyHeight2-7,!JumpyHeight2-17,!JumpyHeight2-10
		
		Jumpy3:
		db !JumpyHeight3,!JumpyHeight3+6,!JumpyHeight3-2,!JumpyHeight3+4,!JumpyHeight3-5
		db !JumpyHeight3+2,!JumpyHeight3-7,!JumpyHeight3,!JumpyHeight3-10,!JumpyHeight3-2
		db !JumpyHeight3-12,!JumpyHeight3-15,!JumpyHeight3-7,!JumpyHeight3-17,!JumpyHeight3-10
		
		JumpyPointers:
		dw Jumpy1
		dw Jumpy2
		dw Jumpy3
%RATS_end(0)