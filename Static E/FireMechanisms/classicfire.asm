;Ignore the comments, they're left over from the old version and have been moved around a bit.

org $02A129
LDA #$02    ; / Make sprite fall down...
STA $14C8,x ; \ ... or disappear in smoke (depends on its settings)
autoclean JSL Mycode
JSL $02ACEF ; Jump to the score routine handler.


freecode

Mycode:
LDY $185E
LDA $1747,y
BMI +
LDA #$20
BRA ++
+
LDA #$E0
++
STA $B6,x

LDA #$05    ; 5 = 100. Changing it will change the amount of score you get (1=10,2=20,3=40,4=80,5=100,6=200,7=400,8=800,9=1000,A=2000,B=4000,C=8000,D=1up)
RTL