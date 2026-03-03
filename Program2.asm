; Programming Assignment 2
; Student Name: Tyler Casey
; UT Eid: tnc824
; You are given an array of student records starting at location x3500.
; The array is terminated by a sentinel. Each student record in the array
; has two fields:
;      Score -  A value between 0 and 100
;      Address of Name  -  A value which is the address of a location in memory where
;                          this student's name is stored.
; The end of the array is indicated by the sentinel record whose Score is -1
; The array itself is unordered meaning that the student records dont follow
; any ordering by score or name.
; You are to perform two tasks:
; Task 1: Sort the array in decreasing order of Score. Highest score first.
; Task 2: You are given a name (string) at location x6100, You have to lookup this student 
;         in the linked list (post Task1) and put the student's score at x60FF (i.e., in front of the name)
;         If the student is not in the list then a score of -1 must be written to x60FF
; Notes:
;       * If two students have the same score then keep their relative order as
;         in the original array.
;       * Names are case-sensitive.

	.ORIG	x3000
;TASK 1
    LD R0, studentArrayLoc   
    and r1, r1, #0 ; arrayLength
    and r2, r2, #0

;find length of the array
measureLength
    LDR R3, R0, #0
    BRn sortArray         
    ADD R1, R1, #1
    ADD r2, r2, #1
    ADD R0, R0, #2        
    BR measureLength       ; Repeat until sentinel is found
    
;measure needed offset
sortArray
    add r1, r1, #0
    BRz T1done
    LD R0, studentArrayLoc   ; Load the start of the array into R0
    not r3, r1
    add r3, r3, #1              ; r3 <- -r1
    add r3, r2, r3
startLoop    
    BRz sorting             ; check if zero, depending on number 
    add r0, r0, #2          ; setting starting location
    ADD r3, r3, #-1        ; counter for startLoop 
    BR startLoop

;Sorting the array 
sorting
    add r3, r0, #0          ; address of holder score
    AND r4, r4, #0          ; address of max
    ADD r5, r4, #-1         ; current max
;finds max in array
innerLoop    
    LDR r6, r0, #0
    BRn swapValues
    not r7, r5
    add r7, r7, #1
    add r7, r6, r7
    BRn skip
    add r4, r0, #0
    add r5, r6, #0
skip    
    add r0, r0, #2
    BR innerLoop

;swaps score and name memory locations
swapValues
    ; Swap scores
    LDR R6, R3, #0         ; Load holder score into R6
    LDR R5, R4, #0         ; Load max score into R5
    STR R5, R3, #0         ; Store max score at the start of the array
    STR R6, R4, #0         ; Store holder score at max score index

    ; Swap names
    LDR R6, R3, #1         ; Load holder name into R6
    LDR R5, R4, #1         ; Load max name into R5
    STR R5, R3, #1         ; Store max name at the start of the array
    STR R6, R4, #1         ; Store holder name at max index

; Move to the next position in the outer loop
    ADD R1, R1, #-1
    BR sortArray

T1done



;TASK 2
    AND r7, r7, #0
    ADD r7, r7, #-1         ; initialize score as -1
    LD r0, studentArrayLoc
    
Outer
    ldr r1, r0, #0          ; loads score, looking for sentinal
    BRn T2done
    LD r2, searchNameLoc       ; searchNameAddress
    add r6, r0, #1          ; nameAddress
    LDR r1, r6, #0          ; name

inner    
    LDR r3, r2, #0          ; letter of searchName
    ; checks for sentinal of searchName 
    BRz matchSentinals
    
    LDR r4, r1, #0          ; letter of name
    BRz endReached         
    
    NOT r5, r4
    AND r5, r5, r3
    BRnp noMatch
; if there is a match    
    add r1, r1, #1
    add r2, r2, #1
    BR inner

noMatch    
    ADD r0, r0, #2
    BR Outer
    
matchSentinals
    ldr r4, r1, #0
    brnp T2done    
    LDR r7, r6, #-1
    
endReached
    add r3,r3,#0 ; new
    BRnp T2done ; new
    LDR r7, r6, #-1
    
T2done
    LD r2, searchNameLoc
    STR r7, r2, #-1                 ; r7 -> x60FF
    
	TRAP	x25
; Your .FILLs go here
studentArrayLoc    .FILL x3500
searchNameLoc      .FILL x6100
	.END

; Student records are at x3500

    .ORIG	x3500
studentArray
    .FILL   #55     ; student 0' score
    .FILL   x4700   ; student 0's nameAddr
    .FILL   #75     ; student 1' score
    .FILL   x4100   ; student 1's nameAdd
    .FILL   #65     ; student 2' score
    .FILL   x4200   ; student 2's nameAdd
	.FILL   #-1
    .END

; Joe
	.ORIG	x4700
	.STRINGZ "Joe"
	.END
; Wow
	.ORIG	x4200
	.STRINGZ "Wonder Woman"
	.END
	
; Bat
	.ORIG	x4100
	.STRINGZ "Bat Man"
	.END


; Person to Lookup	
	.ORIG   x6100
searchName	
;       The following lookup should give score of 55
	.STRINGZ  "Joes"
;       The following lookup should give score of 75
;	.STRINGZ  "Bat Man"
;       The following lookup should give score of -1 because Bat man is 
;           spelled with lowercase m; There is no student with that name 
;	.STRINGZ  "Bat man"
;    .STRINGZ ""  ; should return a -1
;   .Stringz "Joes"  ; should return a -1
	.END
	
