; Program5.asm
; Name(s): Tyler Casey & Barrett Luban
; UTEid(s): tnc824 & bjl2939
; Continuously reads from x3500 making sure its not reading duplicate
; symbols. Processes the symbol based on the program description
; of mRNA processing.
    .ORIG x3000
; set up the keyboard interrupt vector table entry
;M[x0180] <- x2500
    and r7, r7, #0
    LD R0, KBISR
    STI R0, KBINTVec

; enable keyboard interrupts
; KBSR[14] <- 1 ==== M[xFE00] = x4000
    LDI R0, KBSR
    LD R1, KBINTEN
    NOT R0, R0
    NOT R1, R1
    AND R0, R1, R0
    NOT R0, R0
    STI R0, KBSR

RESET
AND R1, R1, #0
Loop
    LDI R0,GLOB
    BRz Loop
    
; Process it
    STI R1, GLOB
    TRAP X21 ; print char
;load char values
    LD R7 A
    LD R3 U
    LD R4 G
    LD R5 C
    
    ADD R6, R0, R7
    BRNP RESET
    
state1
    LDI R0,GLOB
    BRz state1      
    STI R1, GLOB
    TRAP X21
    
    ADD R6, R0, R3
    BRNP RESET
Loop3
    LDI R0,GLOB
    BRz Loop3      
    STI R1, GLOB
    TRAP X21
    ADD R6 R0, R4
    BRNP RESET

ADD R1, R0, #0
LD R0, |    
TRAP X21    ; prints starting sequence
; end of start

ADD R0, R1, #0
AND R1, R1, #0
LOOP4
    LDI R0,GLOB
    BRz LOOP4  
    STI R1, GLOB
TRAP X21
ADD R6 R0, R3
BRZ LOOP6


LOOP5
    LDI R0,GLOB
    BRz LOOP5
    STI R1, GLOB
TRAP X21
ADD R6, R0, R3
BRNP LOOP5


LOOP6
    LDI R0,GLOB
    BRz LOOP6
    STI R1, GLOB
TRAP X21
ADD R6, R0, R5
BRZ LOOP5
ADD R6, R0, R3
BRZ LOOP6
ADD R6, R0, R4
BRZ LOOP8


LOOP7
    LDI R0,GLOB
    BRz LOOP7
    STI R1, GLOB
TRAP X21
ADD R6, R0, R5
BRZ LOOP4
ADD R6, R0, R3
BRZ LOOP6
BR STOP


LOOP8
    LDI R0,GLOB
    BRz LOOP8
    STI R1, GLOB
TRAP X21
ADD R6, R0, R3
BRZ LOOP6
ADD R6, R0, R7
BRZ STOP
BR LOOP4
STOP

; Repeat until Stop Codon detected
    HALT
A   .FILL x-41
C   .FILL x-43
G   .FILL x-47
U   .FILL x-55
|   .FILL x7C
KBINTVec  .FILL x0180
KBSR   .FILL xFE00
KBISR  .FILL x2500
KBINTEN  .FILL x4000
GLOB   .FILL x3500

	.END

; Interrupt Service Routine
; Keyboard ISR runs when a key is struck
; Checks for a valid RNA symbol and places it at x3500
    .ORIG x2500
; Save registers
    ST r1, saveReg1
    ST r2, saveReg2
    
; Code
    LDI r1, KBDR
    
    ld r2, AB
    add r2, r2, r1
    BRz doned
    ld r2, CB
    add r2, r2, r1
    BRz doned
    ld r2, GB
    add r2, r2, r1
    BRz doned
    ld r2, UB
    add r2, r2, r1
    BRz doned
    AND r1, r1, #0
doned
    STI r1, IGLOB
; Restore registers
    LD r1, saveReg1
    LD r2, saveReg2
    
    RTI
        
KBDR  .FILL xFE02
IGLOB  .FILL x3500

AB   .FILL x-41
CB   .FILL x-43
GB   .FILL x-47
UB   .FILL x-55

saveReg1    .BLKW #1
saveReg2    .BLKW #1
		.END
