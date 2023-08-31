;;; 
;;; @brief Hello World as Diagnostic Cart
;;; @author Thomas Cherryhomes
;;; @email thom dot cherryhomes at gmail dot com
;;; @license gpl v. 3, see LICENSE for details.
;;; 
;;; *******************************************************************************************
;;; ***                                                                                     ***
;;; *** The simplest, barest, get-out-of-my-way-let-me-handle-everything cartridge possible ***
;;; *** Using the "Diagnostic Cartridge" flag to tell the Atari to not start the ROM OS,    ***
;;; *** and instead, to jump to the cartridge as soon as possible.                          ***
;;; ***                                                                                     ***
;;; *** So this means, we take care of setting up, at the very least, POKEY, and to point   ***
;;; *** ANTIC to the right place, using the actual hardware registers, instead of the       ***
;;; *** OS shadow registers (e.g. DLIST instead of SDLST)                                   ***
;;; ***                                                                                     ***
;;; *******************************************************************************************
;;;
;;; @note: build with the MAD-Assembler (https://mads.atari8.info/)
;;;

	opt f+			; Fill all bytes with 00 in between the two orgs
	opt h-			; No executable binary header, we'll provide a cart trailer.

	;; Equates to give nice names to hardware register addresses.
	
COLBK	equ $D01A		; GTIA Background color
SKCTL	equ $D20F		; POKEY Control register
DMACTL	equ $D400		; ANTIC DMA control register
DLISTL	equ $D402		; ANTIC Display List pointer (LO)
DLISTH	equ $D403		; ANTIC Display List Pointer (HI)

	;; Start of ROM
	
	org $A000		; Start of the 8K cartridge area ($A000-$BFFF)

	;; Program execution begins here (we specify this in the trailer below)

	;; We have to quickly set up POKEY, at the very least so the system will work.
	
START:	lda #$00		; Clear Pokey SKCTL
	sta SKCTL
	lda #$03		; Then Set to $03
	sta SKCTL

	lda #$22		; Turn on normal playfield DMA
	sta DMACTL
	
	LDA #$CA		; Set background color to GREEN
	STA COLBK

	LDA #<DLIST		; point display list to DLIST
	STA DLISTL
	LDA #>DLIST
	STA DLISTH
	
LOOP:	JMP LOOP

	;; The ANTIC Display list
	;; LMS means Load Memory Store. That is, get the data to display on this line, from the following address
	
DLIST:	
	.BYTE $70		; 8 blank scan lines
	.BYTE $70		; 8 blank scan lines
	.BYTE $70		; 8 blank scan lines
	.BYTE $70		; 8 blank scan lines
	.BYTE $70		; 8 blank scan lines
	.BYTE $70		; 8 blank scan lines
	.BYTE $70		; 8 blank scan lines
	.BYTE $70		; 8 blank scan lines
	.BYTE $70		; 8 blank scan lines
	.BYTE $70		; 8 blank scan lines
	.BYTE $70		; 8 blank scan lines
	.BYTE $70		; 8 blank scan lines
	.BYTE $70		; 8 blank scan lines
	.BYTE $47,<MSG,>MSG	; Mode 6 ($06) (20 columns, 5 colors), + LMS ($40), get display from address of MSG
	.BYTE $41,<DLIST,>DLIST ; Jump after VBlank to DLIST (loop back)

MSG:	.SB "  YOUR ATARI WORKS  "

	;; The Cartridge trailer, at the very end of the ROM.
	
	org $BFFA
	.word START		; Start address
	.byte $00		; should set 0 here so Atari knows there is a cartridge
	.byte $80		; Diagnostic Cartridge, do not initialize anything
	.word START		; init address
	
