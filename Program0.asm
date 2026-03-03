; Programming Assignment 0
; Student Name: Tyler Casey
; UT Eid: TNC824
; You are given three inputs A, B and C stored respectively at addresses, 
;    x30F0, x30F1 and x30F2. 
; Your job is to perform the following operations and store the results at address specified:
; X = A OR B               (store X at x30F4)
; Y = A XOR B              (store Y at x30F5)
; Z = NOT(A OR B OR C)     (store Z at x30F6)
; W = NOT(A) AND NOT(B) AND NOT(C) (store W at x30F7)
; Sum = A + B + C          (store Sum at x30F8)
; Diff= A - B - C          (store Diff at x30f9) 

	.ORIG	x3000
; Your code goes here
LD r4, xEF  ; load a 
LD r5, xEF  ; load b
LD r2, xEF  ; load c

; A OR B  =  (a' AND b')'
add r0, r4, #0 ; a
add r1, r5, #0 ; b
jsr OR 
ST r3, xEC  ; stores r5 in M[x30F4]

; A XOR B = A'B + AB' 
not r0 r4
not r1 r5
AND r0, r0, r5  ; r0 <- a' and b
AND r1, r4, r1  ; r1 <- a and b'
jsr OR
ST r3, xE6      ; stores r5 at M[x30F5]

;NOT(A OR B OR C)
NOT r5, r2  ; c'
not r0 r4
not r1 r5
AND r6, r0, r1  ; a' and b'
AND r7, r6, r5  ; r6 and c'
ST r7, xE3      ; r7 -> M[x30F6]

;NOT(A) AND NOT(B) AND NOT(C)
AND r6, r0, r1  ; r6 <- a' and b'
AND r7, r6, r5  ; r7 <- r6 and c'
ST r7, xE1      ; r7 -> M[x30F7]

;sum = a + b + c
ADD r6, r4, r5  ; r6 <- a + b
ADD r7, r6, r2  ; r7 <- r6 + c
ST r7, xDF      ; r7 -> M[x30F8]

;Diff = a - b - c
ADD r6, r4, #1  ; r6 <- negative b
ADD r6, r0, r6  ; r6 <- a + negative b
ADD r7, r5, #1  ; r <- negative c
ADD r7, r6, r7  ; r7 <- r6 + negative c
ST r7, xDB      ; r7 -> M[x30F9]

HALT


;takes r0 and r1 and ORs them returns in r3
OR
    not r0 r0
    not r1 r1
    and r3 r1 r0
    not r3 r3
    ret
	.END

; Example test cases here
    .ORIG	x30F0
;    .FILL   x0001     ; A
;    .FILL   x0001     ; B
;    .FILL	 x0001     ; C
;    .FILL   x00AA     ; A
;    .FILL   x0055     ; B
;    .FILL	 x0022     ; C
    .FILL   x0ABC     ; A
    .FILL   xDEF0     ; B
    .FILL	x1234     ; C
    .FILL   x0000     ; Barrier
    .BLKW   #1        ; X
    .BLKW   #1        ; Y
    .BLKW   #1        ; Z
    .BLKW   #1        ; W
    .BLKW   #1        ; Sum
    .BLKW   #1        ; Diff
	.END
	

