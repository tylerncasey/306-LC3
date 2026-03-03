;;***********************************************************
; Programming Assignment 3
; Student Name: Tyler Casey
; UT Eid: tnc824
; Simba in the Jungle
; This is the starter code. You are given the main program
; and some declarations. The subroutines you are responsible for
; are given as empty stubs at the bottom. Follow the contract. 
; You are free to rearrange your subroutines if the need were to 
; arise.
; Note: Remember "Callee-Saves" (Cleans its own mess)

;***********************************************************

.ORIG x4000

;***********************************************************
; Main Program
;***********************************************************
    JSR   DISPLAY_JUNGLE
    LEA   R0, JUNGLE_INITIAL
    TRAP  x22 
    LDI   R0,BLOCKS
    JSR   LOAD_JUNGLE
    JSR   DISPLAY_JUNGLE
    LEA   R0, JUNGLE_LOADED
    TRAP  x22                        ; output end message
    TRAP  x25                        ; halt
JUNGLE_LOADED       .STRINGZ "\nJungle Loaded\n"
JUNGLE_INITIAL      .STRINGZ "\nJungle Initial\n"
BLOCKS          .FILL x5500

;***********************************************************
; Global constants used in program
;***********************************************************
;***********************************************************
; This is the data structure for the Jungle grid
;***********************************************************
GRID .STRINGZ "+-+-+-+-+-+-+-+-+"
     .STRINGZ "| | | | | | | | |"
     .STRINGZ "+-+-+-+-+-+-+-+-+"
     .STRINGZ "| | | | | | | | |"
     .STRINGZ "+-+-+-+-+-+-+-+-+"
     .STRINGZ "| | | | | | | | |"
     .STRINGZ "+-+-+-+-+-+-+-+-+"
     .STRINGZ "| | | | | | | | |"
     .STRINGZ "+-+-+-+-+-+-+-+-+"
     .STRINGZ "| | | | | | | | |"
     .STRINGZ "+-+-+-+-+-+-+-+-+"
     .STRINGZ "| | | | | | | | |"
     .STRINGZ "+-+-+-+-+-+-+-+-+"
     .STRINGZ "| | | | | | | | |"
     .STRINGZ "+-+-+-+-+-+-+-+-+"
     .STRINGZ "| | | | | | | | |"
     .STRINGZ "+-+-+-+-+-+-+-+-+"
                   

;***********************************************************
; this data stores the state of current position of Simba and his Home
;***********************************************************
CURRENT_ROW        .BLKW   #1       ; row position of Simba
CURRENT_COL        .BLKW   #1       ; col position of Simba 
HOME_ROW           .BLKW   #1       ; Home coordinates (row and col)
HOME_COL           .BLKW   #1

;***********************************************************
;***********************************************************
;***********************************************************
;***********************************************************
;***********************************************************
;***********************************************************
; The code above is provided for you. 
; DO NOT MODIFY THE CODE ABOVE THIS LINE.
;***********************************************************
;***********************************************************
;***********************************************************
;***********************************************************
;***********************************************************
;***********************************************************
;***********************************************************

;***********************************************************
; DISPLAY_JUNGLE
;   Displays the current state of the Jungle Grid 
;   This can be called initially to display the un-populated jungle
;   OR after populating it, to indicate where Simba is (*), any 
;   Hyena's(#) are, and Simba's Home (H).
; Input: None
; Output: None
; Notes: The displayed grid must have the row and column numbers
;***********************************************************
DISPLAY_JUNGLE
    ;store info
    ST r0, st0
    ST r1, st1
    ST r2, st2
    ST r3, st3
    ST r4, st4
    
    ;beginning of actual code
    LD r2, asciiNum             ; loads ascii value of 0, is the row counter
    AND r1, r1, #0              ; initial counter set at row length
    add r1,r1, #15
    add r1, r1, #2
    LD r4, gridInfo
    LEA r0, columnNumbers
    TRAP x22                    ; prints first line

loop
    BRz done1
    and r0, r1, #1
    BRnp spaceNeeded
    add r0, r2, #0
    TRAP x21        
    LEA r0, space
    TRAP x22            ; prints counter number and a space after
    add r2,r2, #1       ; makes ascii value the next number
    BR skip
    
spaceNeeded
    LEA r0, space
    TRAP x22
    LEA r0, space
    TRAP x22
    BR skip
    
skip
    add r0, r4, #0
    TRAP x22
    LEA r0, newLine
    TRAP x22
    
    
    add r4,r4, #10     ; address of grid shifts down by one row 
    add r4,r4, #8
    add r1,r1, #-1      ; counter increases by 1
    BR loop
    
    ;load info back into registers
done1    
    LD r0, st0
    LD r1, st1
    LD r2, st2
    LD r3, st3
    LD r4, st4
    JMP R7
;info for code    
asciiNum        .FILL #48
space           .STRINGZ " "
columnNumbers   .STRINGZ "   0 1 2 3 4 5 6 7 \n"
newLine         .STRINGZ "\n"
gridInfo        .FILL x402B
;stored info
st0     .blkw #1
st1     .blkw #1
st2     .blkw #1
st3     .blkw #1
st4     .blkw #1

    

;***********************************************************
; LOAD_JUNGLE
; Input:  R0  has the address of the head of a linked list of
;         gridblock records. Each record has four fields:
;       0. Address of the next gridblock in the list
;       1. row # (0-7)
;       2. col # (0-7)
;       3. Symbol (can be I->Initial,H->Home or #->Hyena)
;    The list is guaranteed to: 
;               * have only one Inital and one Home gridblock
;               * have zero or more gridboxes with Hyenas
;               * be terminated by a gridblock whose next address 
;                 field is a zero
; Output: None
;   This function loads the JUNGLE from a linked list by inserting 
;   the appropriate characters in boxes (I(*),#,H)
;   You must also change the contents of these
;   locations: 
;        1.  (CURRENT_ROW, CURRENT_COL) to hold the (row, col) 
;            numbers of Simba's Initial gridblock
;        2.  (HOME_ROW, HOME_COL) to hold the (row, col) 
;            numbers of the Home gridblock
;       
;***********************************************************
LOAD_JUNGLE 
    ;save data
    ST r0, save0
    ST r1, save1
    ST r2, save2
    ST r3, save3
    ST r4, save4
    ST r5, save5
    ST r6, save6
    ST r7, save7
    
    ;actual code
    LDI r3, linkedListInfo
fillLoop
    BRz done3
    LDR r1, r3, #1
    LDR r2, r3, #2
    LDR r4, r3, #3
    
    LD r5, asciiH
    not r5,r5
    add r5, r5, #1
    add r5, r5, r4 ; checks if value is H
    BRz Hfound
    LD r6, asciiI
    not r6,r6
    add r6, r6, #1
    add r6, r6, r4 ; checks if value is I
    BRz Ifound
back
    JSR GRID_ADDRESS
    STR r4, r0, #0
    LDR r3, r3, #0
    BR fillLoop

Hfound    
    LD r5, row&columnInfo
    STR r1, r5, #2
    STR r2, r5, #3
    BR back
Ifound
    LD r5, row&columnInfo
    STR r1, r5, #0
    STR r2, r5, #1
    BR back


    done3
    ;load data back in
    LD r0, save0
    LD r1, save1
    LD r2, save2
    LD r3, save3
    LD r4, save4
    LD r5, save5
    LD r6, save6
    LD r7, save7
    
    JMP  R7
asciiH      .FILL #72
asciiI      .FILL #73
row&columnInfo  .FILL x415D
save0       .blkw #1
save1       .blkw #1
save2       .blkw #1
save3       .blkw #1
save4       .blkw #1
save5       .blkw #1
save6       .blkw #1
save7       .blkw #1
linkedListInfo  .FILL x5500
;***********************************************************
; GRID_ADDRESS
; Input:  R1 has the row number (0-7)
;         R2 has the column number (0-7)
; Output: R0 has the corresponding address of the space in the GRID
; Notes: This is a key routine.  It translates the (row, col) logical 
;        GRID coordinates of a gridblock to the physical address in 
;        the GRID memory.
;***********************************************************
GRID_ADDRESS     
    ST r1, holder1  
    ST r2, holder2
    
    LD r0, gridInfor
    
    add r1, r1, r1
    add r1, r1, #1
    
rowCounter    
    BRz done2
    add r0, r0, #10
    add r0, r0, #8
    add r1, r1, #-1
    BR rowCounter
    
done2     
    add r2, r2, r2
    add r2, r2, #1
    add r0, r0, r2 ; add to the address
   
    LD r1, holder1  
    LD r2, holder2; restores initial values of r1 and r2
    
    JMP R7
gridInfor  .FILL x402B
holder1    .blkw #1
holder2    .blkw #1
    
          .END

; This section has the linked list for the
; Jungle's layout: #(0,1)->H(4,7)->I(2,1)->#(1,1)->#(6,3)->F(3,5)->F(4,4)->#(5,6)
	.ORIG	x5500
	.FILL	Head   ; Holds the address of the first record in the linked-list (Head)
blk2
	.FILL   blk4
	.FILL   #1
    .FILL   #1
	.FILL   x23

Head
	.FILL	blk1
    .FILL   #0
	.FILL   #1
	.FILL   x23

blk1
	.FILL   blk3
	.FILL   #4
	.FILL   #7
	.FILL   x48

blk3
	.FILL   blk2
	.FILL   #2
	.FILL   #1
	.FILL   x49

blk4
	.FILL   blk5
	.FILL   #6
	.FILL   #3
	.FILL   x23

blk7
	.FILL   #0
	.FILL   #5
	.FILL   #6
	.FILL   x23
blk6
	.FILL   blk7
	.FILL   #4
	.FILL   #4
	.FILL   x46
blk5
	.FILL   blk6
	.FILL   #3
	.FILL   #5
	.FILL   x46
	.END	

