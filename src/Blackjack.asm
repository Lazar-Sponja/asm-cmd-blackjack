TITLE ASM Command Line Blackjack  (Blackjack.asm)

INCLUDE Irvine32.inc
;macros for carrage return and linefeed. no need to remember their actual values
lf = 0ah ;'\n'
cr = 0dh ;'\r'

;A struct that specifies a player
Player STRUCT
    cardCount BYTE 0
    pointCount BYTE 0
    winCount  BYTE 0 ;maybe change to like a higher order so more games can be played
    cards BYTE 21 DUP(0)
Player ENDS


.data
welcomeString BYTE "Welcome to the game backend test!", cr, lf,
                   "Here you can (hopefully) test the game logic, without having any of the fancy graphics", cr, lf,
                   "To start choose the number of player. There can not be more then 3 players.", cr, lf,
                   "To choose either press the number 1, 2 or 3", cr, lf, 0
invalidPlayersError BYTE "The number of players you have chosen is invalid, please input either 1, 2 or 3", cr, lf, 0

currentPlayer BYTE "It is the ", 0
st BYTE "st ", 0
nd BYTE "nd ", 0
rd BYTE "rd ", 0
turn BYTE "player's turn", cr, lf ,0

.data?
players Player 4 DUP(<?>) ;Making 3 players plus dealer
nPlayers BYTE ?

.code
main PROC
    ;Print Welcome message
    START: 
    call Randomize ;set random seed
    mov edx, OFFSET welcomeString
    call WriteString
    
    ;Getting number of players
    nPlayerLoop:
        call ReadInt
        cmp eax, 1
        je n
        cmp eax, 2
        je n
        cmp eax, 3
        je n
        ;Invalid input handling
        call Clrscr
        mov edx, OFFSET invalidPlayersError
        call WriteString
        jmp nPlayerLoop
        ;Valid input handling
        n:
        inc al ;include the dealer
        mov nPlayers, al
    gameLoop:

    exit
main ENDP
END main