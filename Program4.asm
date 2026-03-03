;***********************************************************
; Programming Assignment 4
; Student Name: Tyler Casey
; UT Eid: tnc824
; -------------------Save Simba (Part II)---------------------
; This is the starter code. You are given the main program
; and some declarations. The subroutines you are responsible for
; are given as empty stubs at the bottom. Follow the contract. 
; You are free to rearrange your subroutines if the need were to 
; arise.

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
HOMEBOUND
        LEA   R0, LC_OUT_STRING
        TRAP  x22
        LDI   R0,LC_LOC
        LD    R4,ASCII_OFFSET_POS
        ADD   R0, R0, R4
        TRAP  x21
        LEA   R0,PROMPT
        TRAP  x22
        TRAP  x20                        ; get a character from keyboard into R0
        TRAP  x21                        ; echo character entered
        LD    R3, ASCII_Q_COMPLEMENT     ; load the 2's complement of ASCII 'Q'
        ADD   R3, R0, R3                 ; compare the first character with 'Q'
        BRz   EXIT                       ; if input was 'Q', exit
;; call a converter to convert i,j,k,l to up(0) left(1),down(2),right(3) respectively
        JSR   IS_INPUT_VALID      
        ADD   R2, R2, #0                 ; R2 will be zero if the move was valid
        BRz   VALID_INPUT
        LEA   R0, INVALID_MOVE_STRING    ; if the input was invalid, output corresponding
        TRAP  x22                        ; message and go back to prompt
        BRnzp    HOMEBOUND
VALID_INPUT                 
        JSR   APPLY_MOVE                 ; apply the move (Input in R0)
        JSR   DISPLAY_JUNGLE
        JSR   SIMBA_STATUS      
        ADD   R2, R2, #0                 ; R2 will be zero if reached Home or -1 if Dead
        BRp  HOMEBOUND                     ; otherwise, loop back
EXIT   
        LEA   R0, GOODBYE_STRING
        TRAP  x22                        ; output a goodbye message
        TRAP  x25                        ; halt
JUNGLE_LOADED       .STRINGZ "\nJungle Loaded\n"
JUNGLE_INITIAL      .STRINGZ "\nJungle Initial\n"
ASCII_Q_COMPLEMENT  .FILL    x-71    ; two's complement of ASCII code for 'q'
ASCII_OFFSET_POS        .FILL    x30
LC_OUT_STRING    .STRINGZ "\n LIFE_COUNT is "
LC_LOC  .FILL LIFE_COUNT
PROMPT .STRINGZ "\nEnter Move up(i) \n left(j),down(k),right(l): "
INVALID_MOVE_STRING .STRINGZ "\nInvalid Input (ijkl)\n"
GOODBYE_STRING      .STRINGZ "\n!Goodbye!\n"
BLOCKS               .FILL x5500

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
LIFE_COUNT         .FILL   #1       ; Initial Life Count is One
                                    ; Count increases when Simba
                                    ; meets a Friend; decreases
                                    ; when Simba meets a Hyena
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
;   Friends (F) and Hyenas(#) are, and Simba's Home (H).
; Input: None
; Output: None
; Notes: The displayed grid must have the row and column numbers
;***********************************************************
DISPLAY_JUNGLE 
; Your Program 3 code goes here
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
columnNumbers   .STRINGZ "\n   0 1 2 3 4 5 6 7 \n"
newLine         .STRINGZ "\n"
gridInfo        .FILL GRID
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
;       3. Symbol (can be I->Initial,H->Home, F->Friend or #->Hyena)
;    The list is guaranteed to: 
;               * have only one Inital and one Home gridblock
;               * have zero or more gridboxes with Hyenas/Friends
;               * be terminated by a gridblock whose next address 
;                 field is a zero
; Output: None
;   This function loads the JUNGLE from a linked list by inserting 
;   the appropriate characters in boxes (I(*),#,F,H)
;   You must also change the contents of these
;   locations: 
;        1.  (CURRENT_ROW, CURRENT_COL) to hold the (row, col) 
;            numbers of Simba's Initial gridblock
;        2.  (HOME_ROW, HOME_COL) to hold the (row, col) 
;            numbers of the Home gridblock
;       
;***********************************************************
LOAD_JUNGLE 
; Your Program 3 code goes here
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
    LD r4, asciiSimba
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
asciiSimba  .FILL x2A
row&columnInfo  .FILL CURRENT_ROW
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
; Your Program 3 code goes here
    ;save data
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
    
    ; restores initial values of r1 and r2
    LD r1, holder1  
    LD r2, holder2
    
    JMP R7
gridInfor  .FILL GRID
holder1    .blkw #1
holder2    .blkw #1

;***********************************************************
; IS_INPUT_VALID
; Input: R0 has the move (character i,j,k,l)
; Output:  R2  zero if valid; -1 if invalid
; Notes: Validates move to make sure it is one of i,j,k,l
;        Only checks if a valid character is entered
;***********************************************************

IS_INPUT_VALID
;store regs
    st r1, sr1
    st r3, sr3
    
    and r2, r2, #0
    add r1, r0, #0 ; store r0 into r1
    not r1, r1
    add r1, r1, #1 ; r1 <- -r1
    
    ld r3, iB
    add r3, r3, r1
    BRz doned       ; check if input is any of the 4 choices, if not r2 is set to -1
    ld r3, jB
    add r3, r3, r1
    BRz doned
    ld r3, kB
    add r3, r3, r1
    BRz doned
    ld r3, lB
    add r3, r3, r1
    BRz doned
    
    add r2, r2, #-1

doned

;restore regs
    ld r1, sr1
    ld r3, sr3

    JMP R7
iB    .FILL x69
jB    .FILL x6A
kB    .FILL x6B
lB    .FILL x6C
sr1   .blkw #1
sr3   .blkw #1

;***********************************************************
; CAN_MOVE
; This subroutine checks if a move can be made and returns 
; the new position where Simba would go to if the move is made. 
; To be able to make a move is to ensure that movement 
; does not take Simba off the grid; this can happen in any direction.
; In coding this routine you will need to translate a move to 
; coordinates (row and column). 
; Your APPLY_MOVE subroutine calls this subroutine to check 
; whether a move can be made before applying it to the GRID.
; Inputs: R0 - a move represented by 'i', 'j', 'k', or 'l'
; Outputs: R1, R2 - the new row and new col, respectively 
;              if the move is possible; 
;          if the move cannot be made (outside the GRID), 
;              R1 = -1 and R2 is untouched.
; Note: This subroutine does not check if the input (R0) is valid. 
;       You will implement this functionality in IS_INPUT_VALID. 
;       Also, this routine does not make any updates to the GRID 
;       or Simba's position, as that is the job of the APPLY_MOVE function.
;***********************************************************

CAN_MOVE      
    ;save data
    ST r3, reg3
    ST r4, reg4
    ST r5, reg5
    ST r6, reg6
    
    and r1, r1, #0 ; clear r1
    add r6, r1, #-7
    
    LD r4, row&column
    
    ld r3, i
    add r3, r3, r0
    BRz iClick
    
    ld r3, j
    add r3, r3, r0
    BRz jClick
    
    ld r3, k
    add r3, r3, r0
    BRz kClick
    
    ld r3, l
    add r3, r3, r0
    BRz lClick

iClick
    add r1, r1, #-1
    LDR r5, r4, #0 ; r5 <- row num of simba
    BRz donesy
    add r1, r1, r5 ; move up row by 1
    LDR r2, r4, #1 ; load column
    BR donesy
    
jClick
    add r1, r1, #-1
    LDR r5, r4, #1 ; r5 <- column num of simba
    BRz donesy
    LDR r1, r4, #0 ; load row
    add r2, r5, #-1 ; decrease column by 1
    BR donesy
    
kClick
    add r1, r1, #-1
    LDR r5, r4, #0 ; r5 <- row num of simba
    add r6, r6, r5
    BRz donesy
    LDR r2, r4, #1 ; load column
    add r1, r1, #2
    add r1, r5, r1 ; move down row by 1
    BR donesy
    
lClick
    add r1, r1, #-1
    LDR r5, r4, #1 ; r5 <- column num of simba
    add r6, r6, r5
    BRz donesy
    LDR r1, r4, #0 ; load row
    add r2, r5, #1 ; add column by 1
    BR donesy
donesy
    
;restore registers
    LD r3, reg3
    LD r4, reg4
    LD r5, reg5
    LD r6, reg6

    JMP R7
i    .FILL x-69
j    .FILL x-6A
k    .FILL x-6B
l    .FILL x-6C
row&column  .FILL CURRENT_ROW
reg3 .blkw #1
reg4 .blkw #1
reg5 .blkw #1
reg6 .blkw #1





;***********************************************************
; APPLY_MOVE
; This subroutine makes the move if it can be completed. 
; It checks to see if the movement is possible by calling 
; CAN_MOVE which returns the coordinates of where the move 
; takes Simba (or -1 if movement is not possible as detailed above). 
; If the move is possible then this routine moves Simba
; symbol (*) to the new coordinates and clears any walls (|'s and -'s) 
; as necessary for the movement to take place. 
; In addition,
;   If the movement is off the grid - Output "Cannot Move" to Console
;   If the move is to a Friend's location then you increment the
;     LIFE_COUNT variable; 
;   If the move is to a Hyena's location then you decrement the
;     LIFE_COUNT variable; IF this decrement causes LIFE_COUNT
;     to become Zero then Simba's Symbol changes to X (dead)
; Input:  
;         R0 has move (i or j or k or l)
; Output: None; However yous must update the GRID and 
;               change CURRENT_ROW and CURRENT_COL 
;               if move can be successfully applied.
;               appropriate messages are output to the console 
; Notes:  Calls CAN_MOVE and GRID_ADDRESS
;***********************************************************

APPLY_MOVE   
    ; save reg
    ST r0, saver0
    ST r1, saver1
    ST r2, saver2
    ST r3, saver3
    ST r4, saver4
    ST r5, saver5
    ST r6, saver6
    ST r7, saver7
    
    ;code
    and r4, r4, #0
    add r4, r4, r0      ;stores move value into r4, DONT CHANGE
    LD r3, simbaPosition
    LDR r1, r3, #0
    LDR r2, r3, #1      ;simba loc
    
    JSR GRID_ADDRESS
    add r3, r0, #0      ; r3 holds current address of simba
    
    add r0, r4, #0  ; puts move value back into r0
    JSR CAN_MOVE ; r1 and r2 have new row and column, r1 is -1 if cant move
    add r1, r1, #0
    BRn noMove
    
    LD r6, simbaPosition
    STR r1, r6, #0
    STR r2, r6, #1      ; place new row and col into position
    LDR r6, r6, #4      ; r6 gets LIFE_COUNT
    
    JSR GRID_ADDRESS ; r0 now holds new address
    LDR r5, r0, #0 ; r5 holds value in new address DONT CHANGE 

    LD r0, iMove
    add r0, r0, r4
    BRz moveUp
    LD r0, jMove
    add r0, r0, r4
    BRz moveLeft
    LD r0, kMove
    add r0, r0, r4
    BRz moveDown
    LD r0, lMove
    add r0, r0, r4
    BRz moveRight
    
moveUp
    LD r0, spaceVal
    LD r1, simba
    STR r0, r3, #0      ;clears current space of simba
    add r3, r3, #-10
    add r3, r3, #-8     
    
    STR r0, r3, #0      ;move up half a row and clear
    add r3, r3, #-10
    add r3, r3, #-8
    STR r1, r3, #0      ;move up other half to next row and place simba
    BR locCheck
    
moveLeft
    LD r0, spaceVal
    LD r1, simba
    STR r0, r3, #0
    add r3, r3, #-1     ; clear current simba place and move left half a col
    
    STR r0, r3, #0
    add r3, r3, #-1     ; clear this space and move to next col and place simba
    STR r1, r3, #0
    BR locCheck
    
moveDown
    LD r0, spaceVal
    LD r1, simba
    STR r0, r3, #0
    add r3, r3, #10
    add r3, r3, #8      ;clear space and move down half a row
    
    STR r0, r3, #0
    add r3, r3, #10
    add r3, r3, #8
    STR r1, r3, #0      ;clear the space then move down to next row and place simba
    BR locCheck
    
moveRight
    LD r0, spaceVal
    LD r1, simba
    STR r0, r3, #0
    add r3, r3, #1      ; clear space and move right half a row
    
    STR r0, r3, #0
    add r3, r3, #1
    STR r1, r3, #0      ; clear space and move to next col and place simba
    BR locCheck
    
locCheck
    LD r1, simbaPosition
    LD r0, friendly
    add r0, r5, r0
    BRz addLife
    LD r0, hyena
    add r0, r5, r0
    BRz loseLife
    BR finish

addLife
    add r6, r6, #1
    STR r6, r1, #4
    BR finish
    
loseLife
    LD r2, deadVal
    add r6, r6, #-1
    BRnp skipy
    STR r2, r3, #0      ;places X in simba loc if life count is 0
skipy
    STR r6, r1, #4
    BR finish
    
noMove
    LEA r0, cantMove
    TRAP x22
    
finish    
    ; restore reg
    LD r0, saver0
    LD r1, saver1
    LD r2, saver2
    LD r3, saver3
    LD r4, saver4
    LD r5, saver5
    LD r6, saver6
    LD r7, saver7 
    
    JMP R7
cantMove        .STRINGZ "\nCannot Move\n"
simbaPosition   .FILL CURRENT_ROW         ; 0 is current row, 1 is current col, 
                                    ; 2 is home row, 3 is home col, 4 is LIFE_COUNT
iMove    .FILL x-69
jMove    .FILL x-6A
kMove    .FILL x-6B
lMove    .FILL x-6C

deadVal  .FILL x58
spaceVal .FILL x20
friendly .FILL x-46
hyena    .FILL x-23
simba    .FILL x2A

saver0   .blkw #1
saver1   .blkw #1
saver2   .blkw #1
saver3   .blkw #1
saver4   .blkw #1
saver5   .blkw #1
saver6   .blkw #1
saver7   .blkw #1
;***********************************************************
; SIMBA_STATUS
; Checks to see if the Simba has reached Home; Dead or still
; Alive
; Input:  None
; Output: R2 is ZERO if Simba is Home; Also Output "Simba is Home"
;         R2 is +1 if Simba is Alive but not home yet
;         R2 is -1 if Simba is Dead (i.e., LIFE_COUNT =0); Also Output"Simba is Dead"
; 
;***********************************************************

SIMBA_STATUS    
    ; save reg
    ST r0, saved0
    ST r1, saved1
    ST r3, saved3
    ST r4, saved4
    
    ;for reached home
    LD r3, simbaLoc
    LDR r1, r3, #0
    LDR r2, r3, #2      ; load row of simba and home
    not r1, r1
    add r1, r1, #1
    add r2, r2, r1
    BRnp continue 
    
    LDR r1, r3, #1
    LDR r2, r3, #3      ; load col of simba and home
    not r1, r1
    add r1, r1, #1
    add r2, r2, r1
    BRz reachedHome
    
    ;for alive or dead
continue   
    and r2, r2, #0
    LDR r1, r3, #4      ; r1 gets life count
    BRz dead
    add r2, r2, #1      ; r2 gets 1 if alive
    BR allDone
dead
    add r2, r2 #-1
    LEA r0, death
    TRAP x22
    BR allDone
    
reachedHome
    and r2, r2, #0
    LEA r0, homey
    TRAP x22    
    
allDone
    ; restore reg
    LD r0, saved0
    LD r1, saved1
    LD r3, saved3
    LD r4, saved4
    
    JMP R7
simbaLoc   .FILL CURRENT_ROW
homey       .STRINGZ "Simba is Home"
death      .STRINGZ "Simba is Dead"
    
saved0     .blkw #1
saved1     .blkw #1
saved3     .blkw #1
saved4     .blkw #1
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
