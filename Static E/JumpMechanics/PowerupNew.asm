header
lorom

org $01C5A7
JSL Capedit

org $0FDEAA
Capedit:
LDA #$12
STA $1887
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
  LDY #$02
  EXTRA_LOOP:
  LDA $170B,y
  BEQ EXTRA_1
  DEY
  BPL EXTRA_LOOP
  RTS
  EXTRA_1:
  LDA #02
  STA $170B,y
  LDA $E4,x
  STA $171F,y
  LDA $14E0,x
  STA $1733,y
  LDA $D8,x
  STA $1715,y
  LDA $14D4,x
  STA $1729,y
LDA #$A0
  STA $173D,y
LDA #$DA
  STA $1747,y
  LDA #$FF
  STA $176F,y
;;;;;;;;;;;;;;
  LDY #$02
  EXTRA_LOOPa:
  LDA $170B,y
  BEQ EXTRA_2
  DEY
  BPL EXTRA_LOOPa
  RTS
  EXTRA_2:
  LDA #02
  STA $170B,y
  LDA $E4,x
  STA $171F,y
  LDA $14E0,x
  STA $1733,y
  LDA $D8,x
  STA $1715,y
  LDA $14D4,x
  STA $1729,y
LDA #$A0
  STA $173D,y
LDA #$25
  STA $1747,y
  LDA #$FF
  STA $176F,y
LDA #$05
STA $1497
LDA #$77
STA $13E0
LDA #$04
STA $71
RTL

org $01C576
JSL Mushedit

org $0FAB37
Mushedit:
JSL $02ACE5
LDA #$05
STA $1887
LDA #$5E
STA $1DFC
RTL
