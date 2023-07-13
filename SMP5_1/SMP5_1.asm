; C418 - Mellohi
; BPM = 90
; 4分音符 667ms
; 500 167 667 667
	LIST	P=PIC16F84A
	INCLUDE	"P16F84A.INC"

	__CONFIG	_HS_OSC&_WDT_OFF

MOVLF	MACRO	REG, IMM
		MOVLW	IMM
		MOVWF	REG
		ENDM

PLAYS	MACRO	_SCALE
		MOVLF	SCALE, _SCALE
		CALL	PLAY
		ENDM

PLAYLS	MACRO	_LENGTH, _SCALE
		MOVLF	LENGTH, _LENGTH
		PLAYS	_SCALE
		ENDM

CBLOCK	0CH
TMP		;テーブルで使用される
CNT50U	;TIME50Uで使用される
CNT_	;TIME_で使用される
CNTx5	;PLAYx5で使用される
CNT16	;PLAY16で使用される
ARGPRE	;TIME_でのPREループの数
ARGPOST	;TIME_でのメインループの数
ARG16	;PLAY16でのループ数
CNTPLAY	;PLAYで使用される
SCALE	;音階(0:D4)
LENGTH	;音の長さ(1:166)
ENDC

CBLOCK 0H
D4
E4
FS4
G4
GS4
A4
AS4
B4
C5
CS5
D5
DS5
E5
F5
FS5
G5
GS5
A5
ENDC

NOTE16	EQU	1H
NOTE8	EQU	2H
NOTE8D	EQU	3H
NOTE4	EQU	4H
NOTE2D	EQU	12H

	ORG		0H

MAIN
	BSF		STATUS, RP0
	CLRF	TRISB
	BCF		STATUS, RP0
MAINLP
	GOTO	SECTIONS

;出力を反転させる
TOGGLE
	MOVLW	b'00000001'
	XORWF	PORTB, F
	RETURN

;50us・250c(250c*0.2us)
TIME50U						
	MOVLW	052H		; 1c 52H = 82		
	MOVWF	CNT50U		; 1c
	NOP					; 1c
	NOP					; 1c
	NOP					; 1c
LOOP50U
	DECFSZ	CNT50U, F		; 1*(82-1)+2*1 = 83
	GOTO	LOOP50U		; 2*(82-2) = 160
	RETURN				; 2c

;一定時間待つ
;args:
;	ARGPRE
;	ARGPOST
TIME_
	MOVF	ARGPRE, W
	MOVWF	CNT_
LOOP_PRE
	DECFSZ	CNT_, F
	GOTO	LOOP_PRE

	MOVF	ARGPOST, W
	MOVWF	CNT_
LOOP_POST
	CALL	TIME50U
	DECFSZ	CNT_, F
	GOTO	LOOP_POST
	RETURN

;SCALEからARGPREの値を返す
;args:
;	SCALE
PREFROMSCALE
	MOVF	SCALE, W
	MOVWF	TMP
	MOVF	PCL, W
	BCF		STATUS, C
	RLF		TMP, W
	ADDWF	PCL, F
	DT		74H, 92H, 28H, 54H
	DT		86H, 16H, 1H, 47H
	DT		3DH, 39H, 3AH, 3FH
	DT		49H, 2H, 14H, 2AH
	DT		43H, BH

;SCALEからARGPOSTの値を返す
;args:
;	SCALE
POSTFROMSCALE
	MOVF	SCALE, W
	MOVWF	TMP
	MOVF	PCL, W
	BCF		STATUS, C
	RLF		TMP, W
	ADDWF	PCL, F
	DT		20H, 1CH, 1A, 18H
	DT		16H, 16H, 15H, 13H
	DT		12H, 11H, 10H, FH
	DT		EH, EH, DH, CH
	DT		BH, BH

;SCALEからCNT16の値を返す
;args:
;	SCALE
CNT16FROMSCALE
	MOVF	SCALE, W
	MOVWF	TMP
	MOVF	PCL, W
	BCF		STATUS, C
	RLF		TMP, W
	ADDWF	PCL, F
	DT		13H, 16H, 18H, 1AH
	DT		1BH, 1DH, 1FH, 20H
	DT		22H, 25H, 27H, 29H
	DT		2CH, 2EH, 31H, 34H
	DT		37H, 3AH

;5サイクル分音を鳴らす
;args:
;	ARGPRE
;	ARGPOST
PLAYx5
	MOVLW	5H
	MOVWF	CNTx5
LOOPx5
	CALL	TIME_
	CALL	TOGGLE
	DECFSZ	CNTx5, F
	GOTO	LOOPx5
	RETURN

;16分音符分音を鳴らす
;args:
;	ARGPRE
;	ARGPOST
;	ARG16
PLAY16
	MOVF	ARG16, F
	MOVWF	CNT16
LOOP16
	CALL	PLAYx5
	DECFSZ	CNT16, F
	GOTO	LOOP16
	RETURN

;音を鳴らす
;args:
;	SCALE
;	LENGTH
PLAY
	CALL	PREFROMSCALE
	MOVWF	ARGPRE
	CALL	POSTFROMSCALE
	MOVWF	ARGPOST
	CALL	CNT16FROMSCALE
	MOVWF	ARG16

	MOVF	LENGTH, W
	MOVWF	CNTPLAY
LOOPPLAY
	CALL	PLAY16
	DECFSZ	CNTPLAY, F
	GOTO	LOOPPLAY
	RETURN

SECTIONS
	CALL	SECTION1
	CALL	SECTION2

SECTION1
	MOVLF	LENGTH, NOTE2D

	PLAYS	G4
	PLAYS	FS4
	PLAYS	G4
	PLAYS	D4

	PLAYS	GS4
	PLAYS	FS4
	PLAYS	G4
	PLAYS	D4

	PLAYS	G4
	PLAYS	FS4
	PLAYS	D4
	PLAYS	FS4

	PLAYS	C5
	PLAYS	A4
	PLAYS	B4
	PLAYS	G4

	RETURN

SECTION2
	PLAYLS	NOTE8D, G5
	PLAYLS	NOTE16, E5
	PLAYLS	NOTE4, FS5
	PLAYS	A5

	CALL	SECTION2_1

	PLAYS	A5


	PLAYLS	NOTE4, G5
	PLAYS	FS5
	PLAYS	A5

	CALL	SECTION2_1

	PLAYS	GS4

	RETURN

SECTION2_1
	PLAYLS	NOTE8D, FS5
	PLAYLS	NOTE16, E5
	PLAYLS	NOTE4, F5
	PLAYS	A5

	PLAYLS	NOTE8D, F5
	PLAYLS	NOTE16, E5
	PLAYLS	NOTE4, F5
	PLAYS	A5

	PLAYLS	NOTE8D, D5
	PLAYLS	NOTE16, E5
	PLAYLS	NOTE4, F5

	RETURN

	END