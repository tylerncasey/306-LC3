; Programming Project 1 starter file
; Student Name  : Tyler Casey
; UTEid: tnc824
; Modify this code to satisfy the requirements of Program 1
; Compute N^M, where N and M are non-negative inputs to your program.
; The input numbers are given to you in memory locations x3100 (N) and x3101 (M) 
; The computed result has to be placed in x3102 (N2theM). 
; If the computation of the value of NM exceeds x7FFF then you put the 
; value -1 at x3102. Assume 0^0 = 0.
; Read the complete Project Description on the Google doc linked
    .ORIG  x3000
;---- Your Solution goes here	
    LD r1, N
    LD r3, M
    AND r0, r0, #0 ; Clear the location of the sum
    ADD r1, r1, #0
    BRz Done        ; checks if N is 0 and sets sum = 0
    
    ADD r0, r0, #1
    ADD r3, r3, #0
    BRz Done        ; checks if M is 0 and sets sum = 1

    AND r0, r0, #0
    ADD r3, r3, #-1
    BRz Mis1        ; checks if M is 1 and sets sum as n

; math section of the code

outerLoop
    BRz Done  
    AND r5, r5, #0
    LD r2, N        ; counter = N

innerLoop
    BRz CompleteInnerLoop
    ADD r5, r5, r1
    BRn overflow    
    ADD r2, r2, #-1
    BR innerLoop
    
CompleteInnerLoop
    AND r0, r0, #0
    ADD r0, r0, r5
    AND R1, R1, #0
    ADD R1, R0, R1
    ADD r3, r3, #-1
    BR outerLoop
    
;---- Done

Mis1
    AND r0, r0, #0
    ADD r0, r0, r1 ; makes sum = n
    BR Done

overflow
    AND r0, r0, #0
    ADD r0, r0, #-1 ; overflow makes sum = -1
    BR Done
    
Done
    ST r0, N2theM
	HALT
;---- You may declare your stuff here if needed    

    .END
    
;---- Data: Inputs and Output go here
    .ORIG x3100
;N    .FILL x0003 ; used to be x0003
;M    .FILL x0002 ; used to be x0002
;N    .FILL x000A
;M    .FILL x000A
N    .FILL x0002
M    .FILL x000A
;N    .FILL x00B2
;M    .FILL x0002
;N    .FILL x7FFF
;M    .FILL x0001
N2theM  .BLKW #1
    .END