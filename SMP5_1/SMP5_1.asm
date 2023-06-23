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
LOOPCS
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
LOOPD
	CALL	TIME50U		; (2+250)*33 = 8316
	NOP					; 1*33 = 33
	NOP					; 1*33 = 33
	DECFSZ	CNT, F		; 1*(33-1)+2*1 = 34
	GOTO	LOOPC		; 2*(33-2) = 62
	RETURN				; 2c

;8036
TIMEDS
	MOVLW	01FH		; 1c 1FH = 31
	MOVWF	CNT			; 1c
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
LOOPDS
	CALL	TIME50U		; (2+250)*31 = 7812
	NOP					; 31
	NOP					; 31
	NOP					; 31
	DECFSZ	CNT, F		; 1*(31-1)+2*1 = 32
	GOTO	LOOPC		; 2*(31-2) = 58
	RETURN				; 2c

;7585
TIMEE
	MOVLW	01DH		; 1c 1DH = 29
	MOVWF	CNT			; 1c
	NOP
	NOP
	NOP
	NOP
	NOP
	CALL	TIME8c		; 10c
LOOPE
	CALL	TIME50U		; (2+250)*29 = 7308
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP					; 6*29 = 174
	DECFSZ	CNT, F		; 1*(29-1)+2*1 = 30
	GOTO	LOOPC		; 2*(29-2) = 54
	RETURN				; 2c

;7159
TIMEF
	MOVLW	01CH		; 1c 1CH = 28
	MOVWF	CNT			; 1c
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	CALL	TIME8c		; 18c
LOOPF
	CALL	TIME50U		; (2+250)*28 = 7056
	DECFSZ	CNT, F		; 1*(28-1)+2*1 = 29
	GOTO	LOOPC		; 2*(28-2) = 52
	RETURN				; 2c

;6757
TIMEFS
	MOVLW	01AH		; 1c 1AH = 26
	MOVWF	CNT			; 1c
	NOP
	NOP
	CALL	TIME8c
	CALL	TIME8c		;12
LOOPFS
	CALL	TIME50U		; (2+250)*26 = 6552
	NOP
	NOP
	NOP
	NOP					; 104
	DECFSZ	CNT, F		; 1*(26-1)+2*1 = 27
	GOTO	LOOPC		; 2*(26-2) = 48
	RETURN				; 2c

;6377
TIMEG
	MOVLW	019H		; 1c 19H = 25
	MOVWF	CNT			; 1c
	NOP					; 1c
LOOPG
	CALL	TIME50U		; (2+250)*25 = 6300
	DECFSZ	CNT, F		; 1*(25-1)+2*1 = 26
	GOTO	LOOPC		; 2*(25-2) = 46
	RETURN				; 2c

;6019
TIMEGS
	MOVLW	017H		; 1c 17H = 23
	MOVWF	CNT			; 1c
	NOP
	NOP
	NOP
	NOP
	NOP
	CALL	TIME8c		; 15
LOOPGS
	CALL	TIME50U		; (2+250)*23 = 5796
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP					; 138
	DECFSZ	CNT, F		; 1*(23-1)+2*1 = 24
	GOTO	LOOPC		; 2*(23-2) = 42
	RETURN				; 2c

;5681
TIMEA
	MOVLW	016H		; 1c 16H = 22
	MOVWF	CNT			; 1c
	NOP
	NOP
	NOP
	NOP					; 4
LOOPA
	CALL	TIME50U		; (2+250)*22 = 5544
	NOP
	NOP
	NOP					; 66
	DECFSZ	CNT, F		; 1*(22-1)+2*1 = 23
	GOTO	LOOPC		; 2*(22-2) = 40
	RETURN				; 2c

;5362
TIMEAS
	MOVLW	015H		; 1c 15H = 21
	MOVWF	CNT			; 1c
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP					; 6
LOOPAS
	CALL	TIME50U		; (2+250)*21 = 5292
	DECFSZ	CNT, F		; 1*(21-1)+2*1 = 22
	GOTO	LOOPC		; 2*(21-2) = 38
	RETURN				; 2c

;5061
TIMEB
	MOVLW	013H		; 1c 13H = 19
	MOVWF	CNT			; 1c
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP					; 6
LOOPB
	CALL	TIME50U		; (2+250)*19 = 4788
	NOP
	CALL	TIME8c		; 209
	DECFSZ	CNT, F		; 1*(19-1)+2*1 = 20
	GOTO	LOOPC		; 2*(19-2) = 34
	RETURN				; 2c

	END