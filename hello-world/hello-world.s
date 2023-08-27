	opt f+
	opt h-

COLBK	equ $D01A		; Background color
SKCTL	equ $D20F		; Pokey Control register
	
	org $A000

	lda #$00		; Clear Pokey SKCTL
	sta SKCTL
	lda #$03		; Then Set to $03
	sta SKCTL
	
	LDA #$44
	STA COLBK

LOOP:	JMP LOOP
	
	org $BFFA
	.word start		; Start address
	.byte $00		; should set 0 here so Atari knows there is a cartridge
	.byte $80		; Diagnostic Cartridge, do not initialize anything
	.word start		; init address
	
