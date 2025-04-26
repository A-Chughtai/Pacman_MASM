INCLUDE Irvine32.inc
includelib winmm.lib

.data

szCaption db "Hello",0
szText db "HelloWorld",0

PlaySoundA PROTO,
        pszSound:PTR BYTE, 
        hmod:DWORD, 
        fdwSound:DWORD

        goBOOM byte "boom.wav",0
        deviceConnect BYTE "DeviceConnect",0
        SND_ALIAS    DWORD 00010000h
        SND_RESOURCE DWORD 00040005h
        SND_FILENAME DWORD 00020000h

filehandle dd ?
filename byte "Scores.txt",0

Write1 byte " Name : ",0
Write2 byte "Score : ",0

ask byte "Write Your Name : ",0
username byte 256 dup(?)

newline byte 0Dh,0Ah,0

gameover1 byte "   _____          __  __ ______ ____  ________      _______  ",0
gameover2 byte "  / ____|   /\   |  \/  |  ____/ __ \|  ____\ \    / /  __ \ ",0
gameover3 byte " | |  __   /  \  | \  / | |__ | |  | | |__   \ \  / /| |__) |",0
gameover4 byte " | | |_ | / /\ \ | |\/| |  __|| |  | |  __|   \ \/ / |  _  / ",0
gameover5 byte " | |__| |/ ____ \| |  | | |___| |__| | |____   \  /  | | \ \ ",0
gameover6 byte "  \_____/_/    \_\_|  |_|______\____/|______|   \/   |_|  \_\",0                                              


gamestart1 byte "  _____           __  __             ",0
gamestart2 byte " |  __ \         |  \/  |            ",0
gamestart3 byte " | |__) |_ _  ___| \  / | __ _ _ __  ",0
gamestart4 byte " |  ___/ _` |/ __| |\/| |/ _` | '_ \ ",0
gamestart5 byte " | |  | (_| | (__| |  | | (_| | | | |",0
gamestart6 byte " |_|   \__,_|\___|_|  |_|\__,_|_| |_|",0


menul1 byte "  __  __ ___ _  _ _   _ ",0
menul2 byte " |  \/  | __| \| | | | |",0
menul3 byte " | |\/| | _|| .` | |_| |",0
menul4 byte " |_|  |_|___|_|\_|\___/ ",0
                        
                                     

instruction1 byte "You will start from safe zone",0
instruction2 byte "You will collect all the dots AND Khatti Tofi",0
instruction3 byte "After collecting all the dots, you will proceed to bottom right corner",0
instruction4 byte "There will be a portal there to take you to next level",0
instruction5 byte "There are 3 Levels",0
instruction6 byte "At level 3 you will unlock teleport paths",0

colission byte 0

KhattiTofi STRUCT
    xK byte ?
    yK byte ?
    value byte 7
KhattiTofi ENDS

DOT STRUCT
    xDot byte ?
    yDot byte ?
    value byte 1
DOT ENDS

Ghost STRUCT
    xG byte ?
    yG byte ?
    value byte 1
Ghost ENDS

strResult db 16 dup (0)

ground BYTE "------------------------------------------------------------------------------------------------------------------------",0
ground1 BYTE "|",0ah,0
ground2 BYTE "|",0
h1 byte "----------",0
h2 byte "------------------------------",0

dotLine byte "...............",0

x_save byte ?
y_save byte ?

iteration byte 1
count word 0
lives byte 3
level byte 1
gamespeed byte 100

strMenu1 BYTE "1. Play",0
strMenu2 BYTE "2. Instructions",0
strScore BYTE "Your score is : ",0
strLives BYTE "LIVES : ",0
strPause BYTE "PAUSE",0
strLevel BYTE "Level : ",0

score word 1

xPos BYTE 1
yPos BYTE 3

xCoinPos BYTE ?
yCoinPos BYTE ?

inputChar BYTE ?

R1S DOT <>,<>,<>,<>,<>,<>,<>,<>,<>,<>,<>,<>,<>,<>,<>
R1E DOT <>,<>,<>,<>,<>,<>,<>,<>,<>,<>,<>,<>,<>,<>,<>
R2S DOT <>,<>,<>,<>,<>,<>,<>,<>,<>,<>,<>,<>,<>,<>,<>
R2M DOT <>,<>,<>,<>,<>,<>,<>,<>,<>,<>,<>,<>,<>,<>,<>
R2E DOT <>,<>,<>,<>,<>,<>,<>,<>,<>,<>,<>,<>,<>,<>,<>
R3S DOT <>,<>,<>,<>,<>,<>,<>,<>,<>,<>,<>,<>,<>,<>,<>
R3M DOT <>,<>,<>,<>,<>,<>,<>,<>,<>,<>,<>,<>,<>,<>,<>
R3E DOT <>,<>,<>,<>,<>,<>,<>,<>,<>,<>,<>,<>,<>,<>,<>
R4S DOT <>,<>,<>,<>,<>,<>,<>,<>,<>,<>,<>,<>,<>,<>,<>
R4E DOT <>,<>,<>,<>,<>,<>,<>,<>,<>,<>,<>,<>,<>,<>,<>

G1 Ghost <>
G2 Ghost <>
G3 Ghost <>
G4 Ghost <>
G5 Ghost <>
G6 Ghost <>
G7 Ghost <>
G8 Ghost <>
G9 Ghost <>
G10 Ghost <>

T1 KhattiTofi <>
T2 KhattiTofi <>

portal_is_open byte 0

.code
main PROC

    INVOKE PlaySoundA, OFFSET goBOOM, NULL, 20001H      ; SND_ASYNC | SND_FILENAME
    INVOKE MessageBox, NULL, addr szText, addr szCaption, MB_OK


    call gamestart

    call Walls

    ;;              <----GAME---->

    call DrawPlayer

    ;;call CreateRandomCoin
    ;;call DrawCoin

    ;;call Randomize

    gameLoop:

        .if count == 164
            mov count, 0
            call OpenPortal
            mov portal_is_open,1
        .endif

        .if portal_is_open
            .if xPos == 118
                .if yPos == 28
                    .if Level == 3
                        jmp exitgame
                    .else
                        inc level
                        mov portal_is_open,0
                        call Reset
                        jmp gameloop
                    .endif
                .endif
            .endif
        .endif

        .if level == 3
            call useTP
        .endif

        mov esi,offset G1
        call GhostMove
        mov esi,offset G2
        call GhostMove
        mov esi,offset G3
        call GhostMove
        mov esi,offset G4
        call GhostMove
        mov esi,offset G5
        call GhostMove
        mov esi,offset G6
        call GhostMove
        mov esi,offset G7
        call GhostMove
        mov esi,offset G8
        call GhostMove
        mov esi,offset G9
        call GhostMove
        mov esi,offset G10
        call GhostMove


        call checkGhost

        .if colission == 1
            dec lives
            mov colission,0 
            mov xPos,1
            mov yPos,3
            call UpdatePlayer
            call DrawPlayer
        .endif

        .if lives == 0
            jmp exitGame
        .endif



        .if iteration == 30
            mov iteration,1
        .else
            inc iteration
        .endif

        ;;--------------------------------------------------------------

        call EatTofi

        ;;--------------------------------------------------------------

        .if yPos == 3
            mov esi,offset R1S
            Call EatDots
            mov esi,offset R1E
            Call EatDots
        .endif

        .if yPos == 15
            mov esi,offset R2S
            Call EatDots
            mov esi,offset R2M
            Call EatDots
            mov esi,offset R2E
            Call EatDots
        .endif

        .if yPos == 17
            mov esi,offset R3S
            Call EatDots
            mov esi,offset R3M
            Call EatDots
            mov esi,offset R3E
            Call EatDots
        .endif

        .if yPos == 28
            mov esi,offset R4S
            Call EatDots
            mov esi,offset R4E
            Call EatDots
        .endif

        ;;--------------------------------------------------------------


        

        mov eax,white (black * 16)
        call SetTextColor

        ; draw score:
        mov dl,0
        mov dh,0
        call Gotoxy
        mov edx,OFFSET strScore
        call WriteString
        mov ax,score
        call writeDEC

        ; draw lives:
        mov dl,0
        mov dh,1
        call Gotoxy
        mov edx,OFFSET strLives
        call WriteString
        mov eax,0
        mov al,lives
        call writeDEC

        ;;draw LEVEL

        mov dl,100
        mov dh,0
        call Gotoxy
        mov edx,offset strLevel
        call WriteString
        mov eax,0
        mov al,level
        call writeint

        ; get user key input:
        mov eax,0
        mov al,gamespeed
        Call Delay
        call ReadKey
        jz skipinput
        mov inputChar,al

        skipinput:

        mov bl,xPos
        mov bh,yPos

        ; exit game if user types 'x':
        cmp inputChar,"x"
        je exitGame

        cmp inputChar,"w"
        je moveUp

        cmp inputChar,"s"
        je moveDown

        cmp inputChar,"a"
        je moveLeft

        cmp inputChar,"d"
        je moveRight

        cmp inputChar,27
        je PAU

        jmp gameloop
                                        ;;UP MOVEMENT
        moveUp:

        .if bh == 10
            .if bl <= 10
                jmp gameloop
            .endif
            .if bl >= 109
                jmp gameloop
            .endif
            .if bl == 20
                jmp gameloop
            .endif
            .if bl == 60
                jmp gameloop
            .endif
            .if bl == 100
                jmp gameloop
            .endif
        .endif

        .if bh == 17
            .if bl <= 30
                jmp gameloop
            .endif
            .if bl >= 45
                .if bl <= 54
                    jmp gameloop
                .endif
            .endif
            .if bl >= 66
                .if bl <= 75
                    jmp gameloop
                .endif
            .endif
            .if bl >= 89
                jmp gameloop
            .endif
        .endif

        .if bh == 23
            .if bl <= 10
                jmp gameloop
            .endif
            .if bl >= 109
                jmp gameloop
            .endif
        .endif

        .if bh == 20
            .if bl == 40
                jmp gameloop
            .endif
            .if bl == 80
                jmp gameloop
            .endif
        .endif

        cmp yPos,3
        jz gameloop
        call UpdatePlayer
        dec yPos
        call DrawPlayer
        jmp gameLoop

                                        ;;DOWN MOVEMENT
        moveDown:
        
        .if bh == 8
            .if bl <= 10
                jmp gameloop
            .endif
            .if bl >= 109
                jmp gameloop
            .endif
        .endif

        .if bh == 15
            .if bl <=30
                jmp gameloop
            .endif
            .if bl >= 89
                jmp gameloop
            .endif
            .if bl >= 45
                .if bl <= 54
                    jmp gameloop
                .endif
            .endif
            .if bl >= 66
                .if bl <= 75
                    jmp gameloop
                .endif
            .endif
        .endif

        .if bh == 11
            .if bl == 40
                jmp gameloop
            .endif
            .if bl == 80
                jmp gameloop
            .endif
        .endif

        .if bh == 21
            .if bl <= 10
                jmp gameloop
            .endif
            .if bl == 20
                jmp gameloop
            .endif
            .if bl == 60
                jmp gameloop
            .endif
            .if bl == 100
                jmp gameloop
            .endif
            .if bl >= 109
                jmp gameloop
            .endif
        .endif
        
        cmp yPos,28
        jz gameloop
        call UpdatePlayer
        inc yPos
        call DrawPlayer
        jmp gameLoop

                                        ;;LEFT MOVEMENT
        moveLeft:

        .if bl == 21
            .if bh <= 9 
                jmp gameloop
            .endif
            .if bh >= 22
                jmp gameloop
            .endif
        .endif

        .if bl == 61
            .if bh <= 9
                jmp gameloop
            .endif
            .if bh >= 22
                jmp gameloop
            .endif
        .endif 
        
        .if bl == 101
            .if bh <= 9
                jmp gameloop
            .endif
            .if bh >= 22
                jmp gameloop
            .endif
        .endif 

        .if bh == 16
            .if bl == 31
                jmp gameloop
            .endif
            .if bl == 55
                jmp gameloop
            .endif
            .if bl == 76
                jmp gameloop
            .endif
        .endif

        .if bl == 41
            .if bh >= 12
                .if bh <= 19
                    jmp gameloop
                .endif
            .endif
        .endif

        .if bl == 81
            .if bh >= 12
                .if bh <= 19
                    jmp gameloop
                .endif
            .endif
        .endif

        .if bl == 11
            .if bh == 9
                jmp gameloop
            .endif
            .if bh == 22
                jmp gameloop
            .endif
        .endif

        cmp xPos,1
        jz gameLoop
        call UpdatePlayer
        dec xPos
        call DrawPlayer
        jmp gameLoop

                                        ;;RIGHT MOVEMENT
        moveRight:

        .if bl == 19
            .if bh <= 9 
                jmp gameloop
            .endif
            .if bh >= 22
                jmp gameloop
            .endif
        .endif

        .if bl == 59
            .if bh <= 9
                jmp gameloop
            .endif
            .if bh >= 22
                jmp gameloop
            .endif
        .endif 
        
        .if bl == 99
            .if bh <= 9
                jmp gameloop
            .endif
            .if bh >= 22
                jmp gameloop
            .endif
        .endif

        .if bh == 16
            .if bl == 44
                jmp gameloop
            .endif
            .if bl == 65
                jmp gameloop
            .endif
            .if bl == 88
                jmp gameloop
            .endif
        .endif

        .if bl == 39
            .if bh >= 12
                .if bh <= 19
                    jmp gameloop
                .endif
            .endif
        .endif

        .if bl == 79
            .if bh >= 12
                .if bh <= 19
                    jmp gameloop
                .endif
            .endif
        .endif

        .if bl == 108
            .if bh == 9
                jmp gameloop
            .endif
            .if bh == 22
                jmp gameloop
            .endif
        .endif

        cmp xPos,118
        jz gameLoop
        call UpdatePlayer
        inc xPos
        call DrawPlayer
        jmp gameLoop
        
        PAU:

        call pausee

        jmp gameloop

        ;;--------------------------------------------------------------

        call checkGhost

    jmp gameLoop

    exitGame:

    CALL GAMEOVER

    exit
main ENDP

DrawPlayer PROC
    ; draw player at (xPos,yPos):
    mov eax,yellow ;(blue*16)
    call SetTextColor
    mov dl,xPos
    mov dh,yPos
    call Gotoxy
    mov al,"X"
    call WriteChar
    ret
DrawPlayer ENDP

UpdatePlayer PROC
    mov dl,xPos
    mov dh,yPos
    call Gotoxy
    mov al," "
    call WriteChar
    ret
UpdatePlayer ENDP

DrawCoin PROC
    mov eax,yellow ;(red * 16)
    call SetTextColor
    mov dl,xCoinPos
    mov dh,yCoinPos
    call Gotoxy
    mov al,"."
    call WriteChar
    ret
DrawCoin ENDP

CreateRandomCoin PROC
    mov eax,55
    inc eax
    call RandomRange
    mov xCoinPos,al
    mov yCoinPos,27
    ret
CreateRandomCoin ENDP

SetDots1 PROC
    
    mov esi, offset R1S
    mov x_save,33
    mov y_save,3
    mov dl,x_save
    mov dh,y_save
    call Gotoxy
    mov edx,OFFSET dotLine
    call WriteString

    Call SetDots2
    
    mov esi, offset R1E
    mov x_save,73
    mov y_save,3
    mov dl,x_save
    mov dh,y_save
    call Gotoxy
    mov edx,OFFSET dotLine
    call WriteString

    Call SetDots2

    mov esi, offset R2S
    mov x_save,1
    mov y_save,15
    mov dl,x_save
    mov dh,y_save
    call Gotoxy
    mov edx,OFFSET dotLine
    call WriteString

    Call SetDots2

    mov esi, offset R2M
    mov x_save,53
    mov y_save,15
    mov dl,x_save
    mov dh,y_save
    call Gotoxy
    mov edx,OFFSET dotLine
    call WriteString

    Call SetDots2

    mov esi, offset R2E
    mov x_save,104
    mov y_save,15
    mov dl,x_save
    mov dh,y_save
    call Gotoxy
    mov edx,OFFSET dotLine
    call WriteString

    Call SetDots2

    mov esi, offset R3S
    mov x_save,1
    mov y_save,17
    mov dl,x_save
    mov dh,y_save
    call Gotoxy
    mov edx,OFFSET dotLine
    call WriteString

    Call SetDots2

    mov esi, offset R3M
    mov x_save,53
    mov y_save,17
    mov dl,x_save
    mov dh,y_save
    call Gotoxy
    mov edx,OFFSET dotLine
    call WriteString

    Call SetDots2

    mov esi, offset R3E
    mov x_save,104
    mov y_save,17
    mov dl,x_save
    mov dh,y_save
    call Gotoxy
    mov edx,OFFSET dotLine
    call WriteString

    Call SetDots2

    mov esi, offset R4S
    mov x_save,33
    mov y_save,28
    mov dl,x_save
    mov dh,y_save
    call Gotoxy
    mov edx,OFFSET dotLine
    call WriteString

    Call SetDots2
    
    mov esi, offset R4E
    mov x_save,73
    mov y_save,28
    mov dl,x_save
    mov dh,y_save
    call Gotoxy
    mov edx,OFFSET dotLine
    call WriteString

    Call SetDots2

    mov ecx,150

    mov esi,offset R1S
    add esi,2
    mov al,1
    givevalue:

        mov [esi],al
        add esi,3

    loop givevalue

    ret

SetDots1 ENDP

SetDots2 PROC
    
    mov ecx,15

    setinfo:

        mov al,x_save
        mov [esi],al
        inc esi

        mov al,y_save
        mov [esi],al
        inc esi

        inc esi
        
        inc x_save

    loop setinfo
    
    ret
SetDots2 ENDP

EatDots PROC

    mov ecx,15

    eat:
        mov al,[esi]
        .if al == xPos
            add esi,2
            mov al,[esi]
                .if al == 1
                    mov al,0
                    mov [esi],al
                    inc score
                    inc count
                    jmp nigga
                .endif
                jmp nigga
        .endif
        add esi,3
    loop eat

    nigga:

    ret

EatDots ENDP

SetTofi PROC
    mov eax,green
    call SetTextColor
    mov al,'K'
    
    mov T1.xK,1
    mov T1.yK,28
    mov T1.value,7

    mov dl, T1.xK
    mov dh, T1.yK

    call Gotoxy
    call WriteChar
    


    mov T2.xK,118
    mov T2.yK,3
    mov T2.value,7

    mov dl, T2.xK
    mov dh, T2.yK

    call Gotoxy
    call WriteChar
    
    ret

SetTofi ENDP



EatTofi PROC

    mov ah,yPos
    mov al,xPos

    .if ah == T1.yK
        .if al == T1.xK
            .if T1.value == 7
                mov T1.value, 0
                add score,7
                add count,7
            .endif
        .endif
    .endif
    
    .if ah == T2.yK
        .if al == T2.xK
            .if T2.value == 7
                mov T2.value, 0
                add score,7
                add count,7
            .endif
        .endif
    .endif

    ret

EatTofi ENDP



SetGhost PROC

    mov eax,red 
    call SetTextColor
    
    ;;--------------G1--------------
    
    mov dl,4
    mov dh,8
    call Gotoxy
    mov al,"G"
    call WriteChar
    mov G1.xG,dl
    mov G1.yG,dh


    ;;--------------G2--------------
    
    mov dl,4
    mov dh,23
    call Gotoxy
    mov al,"G"
    call WriteChar
    mov G2.xG,dl
    mov G2.yG,dh
    

    ;;--------------G3--------------
    
    mov dl,53
    mov dh,14
    call Gotoxy
    mov al,"G"
    call WriteChar
    mov G3.xG,dl
    mov G3.yG,dh


    ;;--------------G4--------------
    
    mov dl,53
    mov dh,18
    call Gotoxy
    mov al,"G"
    call WriteChar
    mov G4.xG,dl
    mov G4.yG,dh


    ;;--------------G5--------------
    
    mov dl,33
    mov dh,4
    call Gotoxy
    mov al,"G"
    call WriteChar
    mov G5.xG,dl
    mov G5.yG,dh


    ;;--------------G6--------------
    
    mov dl,73
    mov dh,4
    call Gotoxy
    mov al,"G"
    call WriteChar
    mov G6.xG,dl
    mov G6.yG,dh


    ;;--------------G7--------------
    
    mov dl,33
    mov dh,27
    call Gotoxy
    mov al,"G"
    call WriteChar
    mov G7.xG,dl
    mov G7.yG,dh


    ;;--------------G8--------------
    
    mov dl,73
    mov dh,27
    call Gotoxy
    mov al,"G"
    call WriteChar
    mov G8.xG,dl
    mov G8.yG,dh


    ;;--------------G9--------------
    
    mov dl,103
    mov dh,8
    call Gotoxy
    mov al,"G"
    call WriteChar
    mov G9.xG,dl
    mov G9.yG,dh


    ;;--------------G10--------------
    
    mov dl,103
    mov dh,23
    call Gotoxy
    mov al,"G"
    call WriteChar
    mov G10.xG,dl
    mov G10.yG,dh

    ret

SetGhost ENDP

GhostMove Proc

    .if iteration <= 15
        
        mov dh,[esi + 1]
        mov dl,[esi]
        mov al," "
        Call Gotoxy
        call WriteChar
    
        inc dl
        mov [esi],dl

        mov eax,red 
        call SetTextColor
    
        
        call Gotoxy
        mov al,"G"
        call WriteChar

    .else

        mov dh,[esi + 1]
        mov dl,[esi]
        mov al," "
        Call Gotoxy
        call WriteChar
    
        dec dl
        mov [esi],dl

        mov eax,red 
        call SetTextColor
    
        
        call Gotoxy
        mov al,"G"
        call WriteChar        

    .endif

    ret

GhostMove ENDP

checkGhost PROC

    mov al,xPos
    mov ah,yPos

    .if G1.xG == al
        .if G1.yG == ah
            mov colission, 1
            jmp doomed
        .endif
    .endif

    
    .if G2.xG == al
        .if G2.yG == ah
            mov colission, 1
            jmp doomed
        .endif
    .endif


    .if G3.xG == al
        .if G3.yG == ah
            mov colission, 1
            jmp doomed
        .endif
    .endif


    .if G4.xG == al
        .if G4.yG == ah
            mov colission, 1
            jmp doomed
        .endif
    .endif


    .if G5.xG == al
        .if G5.yG == ah
            mov colission, 1
            jmp doomed
        .endif
    .endif
    

    .if G6.xG == al
        .if G6.yG == ah
            mov colission, 1
            jmp doomed
        .endif
    .endif


    .if G7.xG == al
        .if G7.yG == ah
            mov colission, 1
            jmp doomed
        .endif
    .endif


    .if G8.xG == al
        .if G8.yG == ah
            mov colission, 1
            jmp doomed
        .endif
    .endif


    .if G9.xG == al
        .if G9.yG == ah
            mov colission, 1
            jmp doomed
        .endif
    .endif


    .if G10.xG == al
        .if G10.yG == ah
            mov colission, 1
            jmp doomed
        .endif
    .endif

    doomed:

    ret

checkGhost ENDP

OpenPortal PROC

    mov eax,brown
    mov al,"P"

    mov dh,28
    mov dl,119
    call Gotoxy
    call Writechar

    ret

OpenPortal ENDP

Reset Proc

    call Clrscr
    mov InputChar, " "
    mov xPos,1
    mov yPos,3
    call UpdatePlayer
    Call DrawPlayer
    call walls
    call setGhost
    call setDots1
    call SetTofi
    mov iteration,1
    .if level == 2
        mov gamespeed, 75
    .endif
    .if level == 3
        call set_teleport
        mov gamespeed, 50
    .endif

    ret

Reset ENDP

pausee PROC

    mov dh,0
    mov dl,50
    call gotoxy
    mov edx, offset strPause
    call WriteString
    call READCHAR
    mov al," "
    
    mov dh,0
    mov dl,50
    call gotoxy
    call writechar
    

    mov dh,0
    mov dl,51
    call gotoxy
    call writechar
    
    mov dh,0
    mov dl,52
    call gotoxy
    call writechar
    

    mov dh,0
    mov dl,53
    call gotoxy
    call writechar
     
    
    mov dh,0
    mov dl,54
    call gotoxy
    call writechar

    ret

pausee ENDP

set_teleport PROC
    
    mov dl,0
    mov dh,27
    mov al,"<"
    call gotoxy
    call writechar
    
    mov dl,119
    mov dh,4
    mov al,"<"
    call gotoxy
    call writechar


    mov dl,0
    mov dh,5
    mov al,"<"
    call gotoxy
    call writechar
    
    mov dl,119
    mov dh,25
    mov al,"<"
    call gotoxy
    call writechar


    ret
set_teleport ENDP

useTP PROC

    .if yPos == 27
        .if xPos == 1
            call UpdatePlayer
            mov xPos,118
            mov yPos,4
            call DrawPlayer
        .endif
    .endif

    .if yPos == 5
        .if xPos == 1
            call UpdatePlayer
            mov xPos,118
            mov yPos,25
            call DrawPlayer
        .endif
    .endif

    ret
useTP ENDP


;;----------------------------------------------------------------------------------------------------------------------
;;----------------------------------------------------------------------------------------------------------------------
;;----------------------------------------------------------------------------------------------------------------------
;;----------------------------------------------------------------------------------------------------------------------
;;----------------------------------------------------------------------------------------------------------------------
;;----------------------------------------------------------------------------------------------------------------------
;;----------------------------------------------------------------------------------------------------------------------

WALLS PROC


    ;;              <--------BOUNDARY-------->

    
    call SetDots1
    call SetGhost
    call SetTofi

    ; draw ground at (0,29):
    mov eax,blue ;(black * 16)
    call SetTextColor
    
    mov dl,0
    mov dh,29
    call Gotoxy
    mov edx,OFFSET ground
    call WriteString
    
    mov dl,0
    mov dh,2
    call Gotoxy
    mov edx,OFFSET ground
    call WriteString

    mov x_save,0
    mov y_save,2
    mov ecx,27
    left_verticalB:
        mov dl,x_save
        mov dh,y_save
        call Gotoxy
        mov edx,OFFSET ground2
        call WriteString
        inc y_save
    loop left_verticalB
    
    mov x_save,119
    mov y_save,2
    mov ecx,27
    right_verticalB:
        mov dl,x_save
        mov dh,y_save
        call Gotoxy
        mov edx,OFFSET ground2
        call WriteString
        inc y_save
    loop right_verticalB

    ;;              <-------V_WALLS------->

    ;;-----------------------------------------------------------

    mov x_save,20
    mov y_save,3
    mov ecx,7
    vertical1U:
        mov dl,x_save
        mov dh,y_save
        call Gotoxy
        mov edx,OFFSET ground2
        call WriteString
        inc y_save
    loop vertical1U

    mov x_save,20
    mov y_save,22
    mov ecx,7
    vertical1D:
        mov dl,x_save
        mov dh,y_save
        call Gotoxy
        mov edx,OFFSET ground2
        call WriteString
        inc y_save
    loop vertical1D

    ;;-----------------------------------------------------------

    mov x_save,40
    mov y_save,12
    mov ecx,8
    vertical2C:
        mov dl,x_save
        mov dh,y_save
        call Gotoxy
        mov edx,OFFSET ground2
        call WriteString
        inc y_save
    loop vertical2C

    ;;-----------------------------------------------------------

    mov x_save,60
    mov y_save,3
    mov ecx,7
    vertical3U:
        mov dl,x_save
        mov dh,y_save
        call Gotoxy
        mov edx,OFFSET ground2
        call WriteString
        inc y_save
    loop vertical3U

    mov x_save,60
    mov y_save,22
    mov ecx,7
    vertical3D:
        mov dl,x_save
        mov dh,y_save
        call Gotoxy
        mov edx,OFFSET ground2
        call WriteString
        inc y_save
    loop vertical3D

    ;;-----------------------------------------------------------

    mov x_save,80
    mov y_save,12
    mov ecx,8
    vertical4C:
        mov dl,x_save
        mov dh,y_save
        call Gotoxy
        mov edx,OFFSET ground2
        call WriteString
        inc y_save
    loop vertical4C

    ;;-----------------------------------------------------------

    mov x_save,100
    mov y_save,3
    mov ecx,7
    vertical5U:
        mov dl,x_save
        mov dh,y_save
        call Gotoxy
        mov edx,OFFSET ground2
        call WriteString
        inc y_save
    loop vertical5U

    mov x_save,100
    mov y_save,22
    mov ecx,7
    vertical5D:
        mov dl,x_save
        mov dh,y_save
        call Gotoxy
        mov edx,OFFSET ground2
        call WriteString
        inc y_save
    loop vertical5D

    ;;              <-------H_WALLS------->

    ;;-----------------------------------------------------------

    mov dl,1
    mov dh,9
    call Gotoxy
    mov edx,OFFSET h1
    call WriteString

    ;;-----------------------------------------------------------

    mov dl,1
    mov dh,16
    call Gotoxy
    mov edx,OFFSET h2
    call WriteString

    ;;-----------------------------------------------------------

    mov dl,1
    mov dh,22
    call Gotoxy
    mov edx,OFFSET h1
    call WriteString

    ;;-----------------------------------------------------------

    mov dl,45
    mov dh,16
    call Gotoxy
    mov edx,OFFSET h1
    call WriteString

    ;;-----------------------------------------------------------

    mov dl,66
    mov dh,16
    call Gotoxy
    mov edx,OFFSET h1
    call WriteString

    ;;-----------------------------------------------------------

    mov dl,109
    mov dh,9
    call Gotoxy
    mov edx,OFFSET h1
    call WriteString

    ;;-----------------------------------------------------------

    mov dl,89
    mov dh,16
    call Gotoxy
    mov edx,OFFSET h2
    call WriteString

    ;;-----------------------------------------------------------

    mov dl,109
    mov dh,22
    call Gotoxy
    mov edx,OFFSET h1
    call WriteString

    ;;-----------------------------------------------------------

    ret
WALLS ENDP


GAMEOVER PROC

    mov eax,red
    call settextcolor
    
    call clrScr
    
    mov dl,10
    mov dx,10
    call Gotoxy
    mov edx, offset Write1
    call writeString
    mov edx, offset username
    call writeString

    mov dl,12
    mov dx,12
    call Gotoxy
    mov edx, offset Write2
    call writeString
    mov eax,0
    mov ax,score
    call writeDEC

    call READCHAR

    call clrScr


    mov dl,30
    mov dh,10
    call gotoxy
    mov edx,offset gameover1
    call writestring
    
    mov dl,30
    mov dh,11
    call gotoxy
    mov edx,offset gameover2
    call writestring

    mov dl,30
    mov dh,12
    call gotoxy
    mov edx,offset gameover3
    call writestring

    mov dl,30
    mov dh,13
    call gotoxy
    mov edx,offset gameover4
    call writestring

    mov dl,30
    mov dh,14
    call gotoxy
    mov edx,offset gameover5
    call writestring

    mov dl,30
    mov dh,15
    call gotoxy
    mov edx,offset gameover6
    call writestring



    call readchar

    call filee

    call clrScr

    ret
GAMEOVER ENDP

gamestart PROC

    call clrScr
    
    mov eax,red
    call settextcolor

    mov dl,30
    mov dh,10
    call gotoxy
    mov edx,offset gamestart1
    call writestring
    
    mov dl,30
    mov dh,11
    call gotoxy
    mov edx,offset gamestart2
    call writestring

    mov dl,30
    mov dh,12
    call gotoxy
    mov edx,offset gamestart3
    call writestring

    mov dl,30
    mov dh,13
    call gotoxy
    mov edx,offset gamestart4
    call writestring

    mov dl,30
    mov dh,14
    call gotoxy
    mov edx,offset gamestart5
    call writestring

    mov dl,30
    mov dh,15
    call gotoxy
    mov edx,offset gamestart6
    call writestring



    call readchar

    call clrScr

    call menu
    call inputname

    ret
gamestart ENDP


inputname PROC

    call clrScr

    mov dh, 15
    mov dl, 15
    call Gotoxy
    mov edx, offset ask
    call WriteString
    mov edx, offset username
    mov ecx, 255
    call ReadString

    call clrScr

    ret

inputname ENDP

filee PROC

    mov eax,0
    mov ax, score      
    mov ecx, 10        
    xor bx, bx         

divide:
    xor edx, edx        
    div ecx             
    push dx             
    inc bx              
    test eax, eax       
    jnz divide          

    
    mov cx, bx          
    lea si, strResult   
next_digit:
    pop ax
    add al, '0'         
    mov [esi], al       
    inc esi
    loop next_digit



    mov  edx,OFFSET filename
    call CreateOutputFile
    mov  filehandle, EAX


    mov  eax,fileHandle
    mov  edx,OFFSET Write1
    mov  ecx,sizeof Write1
    call WriteToFile

    mov  eax,fileHandle
    mov  edx,OFFSET username
    mov  ecx,sizeof username
    call WriteToFile

    mov  eax,fileHandle
    mov  edx,OFFSET newline
    mov  ecx,sizeof newline
    call WriteToFile

    mov  eax,fileHandle
    mov  edx,OFFSET Write2
    mov  ecx,sizeof Write2
    call WriteToFile

    mov  eax,fileHandle
    mov  edx,OFFSET strResult
    mov  ecx,sizeof strResult
    call WriteToFile

    mov  eax,fileHandle
    mov  edx,OFFSET newline
    mov  ecx,sizeof newline
    call WriteToFile

    mov  eax,fileHandle
    mov  edx,OFFSET strLevel
    mov  ecx,sizeof strLevel
    call WriteToFile

    add level,48

    mov  eax,fileHandle
    mov  edx,OFFSET level
    mov  ecx,sizeof level
    call WriteToFile

    mov  eax,fileHandle
    mov  edx,OFFSET newline
    mov  ecx,sizeof newline
    call WriteToFile

    mov  eax,fileHandle
    mov  edx,OFFSET newline
    mov  ecx,sizeof newline
    call WriteToFile

    mov  eax,fileHandle
    call CloseFile

    ret
filee ENDP


menu PROC

    mov eax,red
    call settextcolor

    mov dl,50
    mov dh,3
    call gotoxy
    mov edx,offset menul1
    call writestring

    mov dl,50
    mov dh,4
    call gotoxy
    mov edx,offset menul2
    call writestring

    mov dl,50
    mov dh,5
    call gotoxy
    mov edx,offset menul3
    call writestring

    mov dl,50
    mov dh,6
    call gotoxy
    mov edx,offset menul4
    call writestring

    mov dl,40
    mov dh,10
    call Gotoxy
    mov edx, offset strmenu1
    call WriteString

    mov dl,40
    mov dh,12
    call Gotoxy
    mov edx, offset strmenu2
    call WriteString

    again:
    
    call ReadChar

    .if al == '1'
        ret
    .endif

    .if al == '2'
        call INSTRUCTIONS
        ret
    .endif



    jmp again

    ret

menu ENDP

instructions PROC

    mov dl,10
    mov dh,6
    Call Gotoxy
    mov edx, offset instruction1
    call writestring

    mov dl,10
    mov dh,8
    Call Gotoxy
    mov edx, offset instruction2
    call writestring

    mov dl,10
    mov dh,10
    Call Gotoxy
    mov edx, offset instruction3
    call writestring

    mov dl,10
    mov dh,12
    Call Gotoxy
    mov edx, offset instruction4
    call writestring

    mov dl,10
    mov dh,14
    Call Gotoxy
    mov edx, offset instruction5
    call writestring

    mov dl,10
    mov dh,16
    Call Gotoxy
    mov edx, offset instruction6
    call writestring

    call READCHAR

    ret

instructions ENDP

END main

