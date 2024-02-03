; for any pressed button let the cage move to the floor and
; light the floor led with floor number on 7-segment.

CODE    SEGMENT
ASSUME  CS:CODE,DS:CODE,ES:CODE,SS:CODE
        ;
PPI       EQU     26H
CPORT     EQU     24H
BPORT     EQU     22H
APORT     EQU     20H
          ;
          ORG     1000H
          ;
          MOV     AL,90H
          OUT     PPI,AL
          ;
          MOV     BX,0
          MOV     DX,0
          
START:    ;TO INSERT FROM THE BUTTONS
          IN      AL,APORT
          AND     AL,0FH
          
          CMP     AL,0EH ;COMPARE WITH 1F
          JE      FLOOR_1
          
          CMP     AL,0DH ;COMPARE WITH 2F
          JE      FLOOR_2

          CMP     AL,0BH ;COMPARE WITH 3F
          JE      FLOOR_3

          CMP     AL,07H ;COMPARE WITH 4F
          JE      FLOOR_4
          
          JMP     START
          
FLOOR_1:  IN      AL,APORT
          AND     AL,0F0H

          CMP     AL,00010000B   ; SEE IF REACHED FLOOR1
          JNE     F1
          
          MOV     DL,11101111B
          MOV     BL,11111001B
          JMP     STOP
          
F1:       MOV     AL,11101001B
          OUT     CPORT,AL
          JMP     FLOOR_1  ;END OF FLOOR_1
          
FLOOR_4:  IN      AL,APORT
          AND     AL,0F0H

          CMP     AL,10000000B   ; SEE IF REACHED FLOOR4
          JNE     F4
          
          MOV     DL,01111111B
          MOV     BL,10011001B
          JMP     STOP

F4:       MOV     AL,01110110B
          OUT     CPORT,AL
          
          JMP     FLOOR_4  ;END OF FLOOR_4

FLOOR_2:  IN      AL,APORT
          AND     AL,0F0H

          CMP     AL,00100000B   ; SEE IF REACHED FLOOR2
          JNE     F2
          MOV     DL,11011111B
          MOV     BL,10100100B
          JMP     STOP

F2:       CMP     AL,00010000B
          JNE     DOWN
          
          MOV     AL,11010110B
          OUT     CPORT,AL ; GO UP
          JMP     FLOOR_2
          
DOWN:     MOV     AL,11011001B
          OUT     CPORT,AL

          JMP     FLOOR_2 ;END OF FLOOR_2


FLOOR_3:  IN      AL,APORT
          AND     AL,0F0H

          CMP     AL,01000000B   ; SEE IF REACHED FLOOR3
          JNE     F3
          
          MOV     DL,10111111B
          MOV     BL,10110000B
          JMP     STOP

F3:       CMP     AL,10000000B
          JNE     UP

          MOV     AL,10111001B
          OUT     CPORT,AL ; GO DOWN
          JMP     FLOOR_3

UP:       MOV     AL,10110110B
          OUT     CPORT,AL

          JMP     FLOOR_3 ;END OF FLOOR_3
          
          
STOP:     MOV     AL,DL
          OUT     CPORT,AL

          MOV     AL,BL
          OUT     BPORT,AL
          MOV     AL,00H
          MOV     DL,00H
          MOV     BL,00H
          JMP     START

          ;INT     3

CODE      ENDS
          END
          
