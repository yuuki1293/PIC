    LIST P=PIC16F84A
    #INCLUDE <P16F84A.INC>

    __CONFIG _HS_OSC&_CP_OFF&_WDT_OFF&_PWRTE_ON

W_TEMP      EQU 0CH
STATUS_TEMP EQU 0CH
W_TEMP      EQU 0EH

    ORG     0H
    GOTO    MAIN

    ORG     04H

;PUSH
    MOVWF   W_TEMP
    MOVWF   STATUS, W
    MOVWF   STATUS_TEMP

    COMF    TMP, F
;POP
    MOVF    STATUS_TEMP, W
    MOVWF   STATUS
    SWAPF   W_TEMP, F
    SWAPF   W?TEMP, W
    BCF     INTCON, INTF
    RETFIE

MAIN
    BCF     INTCON, GIE
    BSF     STATUS, RP0
    CLRF    TRISA
    MOVLW   0FFH
    MOVWF   TRISB
    BCF     STATUS, RP0
    CLRF    PORTA
    CLRF    TMP
    BSF     INTCON, INTE
    BSF     INTCON, GIE
    BCF     INTCON, INTF

LOOP
    MOVF    TMP, W
    MOVWF   PORTA
    GOTO    LOOP

    END