	LIST	P=PIC16F84A
	INCLUDE	"P16F84A.INC"
		
	__CONFIG	_HS_OSC&_WDT_OFF
	
CNT1	EQU	0CH
CNT		EQU	0DH
MEM		EQU	0EH

	ORG		0H

MAIN
	BSF		STATUS, RP0
	CLRF	TRISB
	BCF		STATUS, RP0
	CALL	INIT
MAINLP
	BSF		PORTB, 0
	CALL	MEM
	BCF		PORTB, 0
	CALL	MEM
	GOTO	MAINLP

INIT
	MOVLW	TIMEC
	MOVWF	MEM
	RETURN

;8c
TIME8c
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	RETURN

;50us・250c(250c*0.2us)
TIME50U						
	MOVLW	052H		; 1c 52H = 82		
	MOVWF	CNT1		; 1c
	NOP					; 1c
	NOP					; 1c
	NOP					; 1c
LOOP1
	DECFSZ	CNT1,F		; 1*(82-1)+2*1 = 83
	GOTO	LOOP1		; 2*(82-2) = 160
	RETURN				; 2c

;9554c
TIMEC
	MOVLW	024H		; 1c 24H = 36
	MOVWF	CNT			; 1c
	CALL	TIME8c		; 2 + 8 = 10
	NOP
	NOP
	NOP
LOOPC
	CALL	TIME50U		; (2+250)*36 = 9072
	CALL	TIME8c		; (2+8)*36 = 360
	DECFSZ	CNT, F		; 1*(36-1)+2*1 = 37
	GOTO	LOOPC		; 2*(36-2) = 68
	RETURN				; 2c

;9019
TIMECS
	MOVLW	023H		; 1c 23H = 35
	MOVWF	CNT			; 1c
	CALL	TIME8c
	CALL	TIME8c
	NOP
	NOP
	NOP
LOOPC
	CALL	TIME50U		; (2+250)*35 = 8820
	NOP					; 1*35 = 35
	NOP					; 1*35 = 35
	DECFSZ	CNT, F		; 1*(35-1)+2*1 = 36
	GOTO	LOOPC		; 2*(35-2) = 66
	RETURN				; 2c

;8512
TIMED
	MOVLW	021H		; 1c 21H = 33
	MOVWF	CNT			; 1c
LOOPC
	CALL	TIME50U		; (2+250)*33 = 8316
	NOP					; 1*33 = 33
	NOP					; 1*33 = 33
	DECFSZ	CNT, F		; 1*(33-1)+2*1 = 34
	GOTO	LOOPC		; 2*(33-2) = 62
	RETURN				; 2c

	END