!WalkingLeft = $EF	; Walking speed going left. Must be somewhere between 80 and FF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
!WalkingLeftAccel = $FD	; Acceleration speed going left. Must be somewhere between 80 and FF
;
!RunningLeft = $CF ; Runnning speed going left. Must be somewhere between 80 and FF
;
!RunningLeftAccel = $EF ; Running acceleration speed going left. Must be somewhere between 80 and FF
;
!WalkingRight = $10 	; Walking speed going right. Must be somewhere between 00 and 7F
;
!RunningRight = $30	; Running speed going right. Must be somewhere between 00 and 7F
;
!WalkingRightAccel = $02; Acceleration speed going rightt. Must be somewhere between 00 and 7F
;
!RunningRightAccel = $10 ; Running acceleration speed going right. Must be somewhere between 00 and 7F
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

header
lorom


org $00D345	
db !WalkingLeftAccel,!WalkingLeft

org $00D347	
db !RunningLeftAccel,!RunningLeft

org $00D349	
db !WalkingRightAccel,!WalkingRight

org $00D34B	
db !RunningRightAccel,!RunningRight