@xkas
header
lorom

org $0294C1
JSL Bouncylol
NOP
JSL Jumponly
RTL

org $0FAEFB
Bouncylol:
LDA #$01
STA $1407
LDA #$95
STA $7D
LDA #$30
RTL

org $0FBEFB
Jumponly:
LDX #$09
JumpLoop:
LDA $1588,x
AND #$04
BEQ Skip
LDA #$C0
Skip:
DEX 
CPX #$00
BPL JumpLoop
RTL


