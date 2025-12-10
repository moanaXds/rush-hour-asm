INCLUDE Irvine32.inc
INCLUDELIB winmm.lib
PlaySoundA PROTO STDCALL :PTR BYTE, :DWORD, :DWORD



.data


game               BYTE "           R U S H   H O U R   G A M E",0
menu1              BYTE "1. Play New Game",0
menu2              BYTE "2. Game Instructions",0
menu3              BYTE "3. Leaderboard",0
menu4              BYTE "4. Exit",0
songFile           BYTE "song.wav", 0





choice             BYTE "Select an Option",0
difficult          BYTE "Choose Dificulty level :  [1: Career mode ]   [2: Time mode ]:",0
colorCar           BYTE "Choose Taxi: [1:Red speedy] [2: Yellow slow ]", 0
nameDriver         BYTE "Enter Driver Name: ", 0
gameOver           BYTE "Game is Over! Your total Score : ",0
gamePause          BYTE "P A U S E D  [ P to Resume ]",0
gameScore          BYTE "[ Score: ", 0
DropsNo            BYTE " ], Drops: ", 0
timeMsg            BYTE "   Time Left: ", 0 



instruct           BYTE "            I N S T R U C T I O N S",0
instruct1          BYTE "1. Use Arrows to move  [ LEFT /RIGHT /UP /DOWN ]",0
instruct2          BYTE "2. Use Space to Pick AND Drop Passengers",0
instruct3          BYTE "3. P is Passengers while D is destiny",0
instruct4          BYTE "4. Obstucles [Brown:Buildings]   [Green:Trees]   [Blue:Cars]",0
instruct5          BYTE "5. P to resume while ESc to End",0
toExit             BYTE "Press random key to return", 0




file               BYTE "HIGHSCORE.txt",0
fileHandle         handle ?
scoreBuffer        BYTE 500 dup(?)
newline            BYTE 0Ah,0Dh,0
 


gameMode           DWORD 0       
startTime          DWORD 0    
timeLimit          DWORD 60000  


playerName         BYTE 20 dup(0)
score              SDWORD 0
dropCount          DWORD 0
speed              DWORD 100 
carshape           BYTE 219
carcolor           DWORD 14
x                  DWORD 1
y                  DWORD 1
isPassen           DWORD 0
xDestiny           DWORD 0
yDestiny           DWORD 0


widths             EQU 20
hights             EQU 20
grid               BYTE widths * hights dup(0)


xOther             DWORD 3 dup(0)
yOther             DWORD 3 dup(0)
directOther        DWORD 3 dup(0)


leadboard          BYTE "     L E A D E R B O A R D ",0
first              BYTE "asd          18", 0
second             BYTE "mam          14", 0
third              BYTE "noor         11", 0
fourth             BYTE "ali          9", 0
fifth              BYTE "rds          3", 0


.code



main PROC
    
    call Randomize

    Game_Global_Menu_Loop:
        call clrscr

        call crlf
        mov edx, offset game
        call writestring
        call crlf
        call crlf

        mov edx, offset menu1
        call writestring
        call crlf
        
        mov edx, offset menu2
        call writestring
        call crlf
        
        mov edx, offset menu3
        call writestring
        call crlf

        mov edx, offset menu4
        call writestring
        call crlf
        call crlf

        mov edx, offset choice
        call writestring

        call readchar

        cmp al, '1'
        je startgamePROC

        cmp al, '2'
        je instructionsPROC

        cmp al, '3'
        je leaderboardPROC

        cmp al, '4'
        je statexitPROC
        jmp Game_Global_Menu_Loop



    startgamePROC :
        call StartMusic
        call Gameplay
        jmp Game_Global_Menu_Loop

    instructionsPROC :
        call InstructionsDisplay
        jmp Game_Global_Menu_Loop

    leaderboardPROC :
        call LeaderboardDisplay
        jmp Game_Global_Menu_Loop

    statexitPROC :
        exit

main ENDP






InstructionsDisplay PROC
    call clrscr

    call crlf
    mov edx, offset instruct
    call writestring
    call crlf
    call crlf

    mov edx, offset instruct1
    call writestring
    call crlf
        
    mov edx, offset instruct2
    call writestring
    call crlf
        
    mov edx, offset instruct3
    call writestring
    call crlf

    mov edx, offset instruct4
    call writestring
    call crlf

    mov edx, offset instruct5
    call writestring
    call crlf
    call crlf

    mov edx, offset toExit
    call writestring
    call readchar
    ret
InstructionsDisplay ENDP


LeaderboardDisplay PROC
    call clrscr

    mov edx, offset file
    call OpenInputFile

    mov fileHandle, eax
    mov edx, offset scoreBuffer
    mov ecx, 500
    call readfromfile

    mov scoreBuffer[eax], 0           ; make string  , eax= no of read bytes

    mov edx, offset scoreBuffer
    call writestring
    
    mov dl, 0
    mov dh, 1
    call Gotoxy

    mov edx, offset first
    call WriteString
    call crlf

    mov edx, offset second
    call WriteString
    call crlf

    mov edx, offset third
    call WriteString
    call crlf

    mov edx, offset fourth
    call WriteString
    call crlf

    mov edx, offset fifth
    call WriteString
    call crlf
    call crlf

    mov eax, fileHandle
    call CloseFile
    jmp Exits


    Exits :
        call crlf
        call WaitMsg
        ret
LeaderboardDisplay ENDP


SaveHighscore PROC
    mov edx, offset file
    call createoutputfile

    mov fileHandle, eax

    mov edx, offset playerName
    mov ecx, lengthof playerName

    mov eax, fileHandle
    call writetofile

    mov eax, fileHandle
    call closefile
    ret
SaveHighscore ENDP

;                                            GAME PLAY 



Gameplay PROC

    call clrscr

    mov edx, offset nameDriver
    call writestring
    call crlf

    mov edx, offset playerName
    mov ecx,19
    call readstring

    mov edx, offset difficult
    call writestring
    call crlf

    call readchar
    cmp al, '2'
    je SetTimeMode

    mov gameMode, 0       
    jmp AskCarColor

    SetTimeMode:
    mov gameMode, 1      

    AskCarColor:
        call crlf

    mov edx, offset colorCar
    call writestring
    call readchar

    cmp al, '1'
    je REDtaxi

    mov carcolor, 14
    mov speed, 50
    jmp initializeVariables

    REDtaxi :
        mov carcolor, 12
        mov speed, 90

    initializeVariables:
        mov isPassen, 0
        mov score, 0
        mov dropCount, 0
        mov x, 1
        mov y, 1
        call initializeBoard
        call drawOthercars
    
    call clrscr   

    call GetMseconds
    mov startTime, eax

    moveMyCar:
        
        cmp gameMode, 1
        jne SkipTimeCheck

        call GetMseconds
        sub eax, startTime    

        cmp eax, timeLimit    
        jae displayEndgame    

        SkipTimeCheck:


        call drawBoard
        call drawScoreDrop

        call ReadKey  ; in dx
        jz LemmeMove

        cmp al, VK_ESCAPE
        je displayEndgame


        cmp al, 'p'
        je PauseState

        cmp dx, VK_UP
        je moveUp

        cmp dx, VK_DOWN
        je moveDown

        cmp dx, VK_LEFT
        je moveLeft

        cmp dx, VK_RIGHT
        je moveRight

        cmp al, ' '
        je pick_drop
        jmp LemmeMove

        moveUp :
            mov eax,y
            mov ebx,x
            dec eax
            call CheckCollisionXY  ; collide eax==1
            cmp eax, 1
            jne LemmeMove
            
            dec y
            jmp LemmeMove

        moveDown :
            mov eax,y
            mov ebx,x
            inc eax
            call CheckCollisionXY  ; in eax
            cmp eax, 1
            jne LemmeMove
            
            inc y
            jmp LemmeMove

        moveLeft :
            mov eax,y
            mov ebx,x
            dec ebx
            call CheckCollisionXY  ; in eax
            cmp eax, 1
            jne LemmeMove
            
            dec x
            jmp LemmeMove

        moveRight :
            mov eax,y
            mov ebx,x
            inc ebx
            call CheckCollisionXY  ; in eax
            cmp eax, 1
            jne LemmeMove
            
            inc x
            jmp LemmeMove


        pick_drop :
            call PickAndDropPassenger
            jmp LemmeMove

        PauseState :
            mov edx, offset gamePause
            call writestring
            call readchar

            mov dl, 0
            mov dh, 0
            call Gotoxy
            jmp moveMyCar

    LemmeMove :
        call moveOtherCars
        mov eax, speed
        call Delay
        jmp moveMyCar

    displayEndgame :
        call StopMusic
        call clrscr
        mov edx, offset gameOver
        call writestring

        mov eax, score
        call WriteInt
        call crlf
        call SaveHighscore
        call WaitMsg
        ret
Gameplay ENDP




moveOtherCars PROC
    
    mov ecx, 3
    mov esi, 0

    moveLoop:

        MoveLogic:
            mov eax, directOther[esi]

            cmp eax, 0                   ; let 0=up , 1=down, 2=left, 3=right
            je moveUp

            cmp eax, 1
            je moveDown

            cmp eax, 2
            je moveLeft

            cmp eax, 3
            je moveRight

        moveUp :
            dec yOther[esi]
            cmp yOther[esi],1      ; got hit upper wall
            jg lememove            ; still inside man
            mov yOther[esi],14
            jmp lememove

        moveDown :
            inc yOther[esi]
            cmp yOther[esi],10
            jl lememove
            mov yOther[esi],1
            jmp lememove

        moveLeft :
            dec xOther[esi]
            cmp xOther[esi],1
            jg lememove
            mov xOther[esi],15
            jmp lememove

        moveRight :
            inc xOther[esi]
            cmp xOther[esi],16
            jl lememove
            mov xOther[esi],4
            jmp lememove


        lememove :
            add esi, 4

            dec ecx
            cmp ecx, 0
            je goReturn
            jmp moveLoop

        goReturn :
            ret
moveOtherCars ENDP





CheckCollisionXY PROC
    push esi
    push edx
    push ecx
    push edi
    
    mov edi, eax                 ; edi=y , ebx=x
    imul edi, widths             ; EDI = Y * Width
    add edi, ebx 

    mov esi,offset grid
    mov dl, [esi+edi]                ; store curr cell value 1,2,3,5 in dl

    cmp dl,1
    je collideWall

    cmp dl,2
    je collideObstacle
    
    cmp dl,3
    je collectDollers

    cmp dl,5      
    je collideObstacle
    
    mov ecx, 0         ;      counter
    mov esi, 0         ;      for other car indexing 
    
    othersCarCollisionCheck:
        cmp ecx, 3
        jge movAllow

        cmp ebx, xOther[esi]  ; x != xOther
        jne checkNextcar

        cmp eax, yOther[esi]
        je got_hitCar
        
        checkNextcar:
            add esi, 4
            inc ecx
            jmp othersCarCollisionCheck

    got_hitCar:
        jmp collideCar


    collectDollers:
        add score, 10          
        mov byte ptr[esi+edi], 0      ;    clear tile
        jmp movAllow     

    movAllow:
        mov eax, 1                    ;    eax=1=allow  
        jmp returnEAX

    collideWall:
        mov eax, 0                    ;    eax=0=don't 
        jmp returnEAX

    collideObstacle:
        cmp carcolor, 12
        je ifRed
        
        sub score, 4   ; yello
        mov eax, 0
        jmp returnEAX

    ifRed:
        sub score, 2 
        mov eax, 0
        jmp returnEAX

    collideCar:
        cmp carcolor, 12
        je RedCarDmg
        
        sub score, 2  ; Yellow hit other car
        mov eax, 0
        jmp returnEAX

    RedCarDmg:
        sub score, 3  
        mov eax, 0
        jmp returnEAX

    returnEAX :
        pop edi
        pop ecx
        pop edx
        pop esi
        ret

CheckCollisionXY ENDP


                                 

PickAndDropPassenger PROC
    mov eax, y
    imul eax, widths
    add eax, x
    mov esi, offset grid

    cmp isPassen, 1
    je goDrop

    cmp byte ptr[esi+eax], 4
    jne Returns

    mov isPassen, 1
    mov byte ptr[esi+eax], 0
                                 ; 1 drop= new P + D  
    call drawDestiny
    call drawPassenger

    ret

goDrop:
    mov eax, y
    mov ebx, x
    cmp ebx, xDestiny
    jne Returns

    cmp eax, yDestiny
    jne Returns

    mov isPassen, 0
    add score, 10
    inc dropCount

    test dropCount, 1
    jnz Returns

    cmp speed, 10
    jbe Returns

    sub speed, 10

Returns:
    ret

PickAndDropPassenger ENDP




initializeBoard PROC
    mov ecx, widths* hights   ; tiles
    mov esi, offset grid

    mov edi,0

    ; fill 0

    fillallZero:
        mov byte ptr[esi+edi],0
        inc edi
        dec ecx
        cmp ecx, 0
        jne fillallZero



    ; fill 1

    ; l1 = rows = edx < higths
    ; l2 = cols = ecx < widths

    mov edx, 0
    L1:
        mov ecx, 0

        L2 :
            cmp edx, 0    ;  higths=0
            je drawWalls

            cmp edx, 19
            je drawWalls

            cmp ecx, 0    ; width=0
            je drawWalls

            cmp ecx, 19   
            je drawWalls

            jmp nextColumn

            drawWalls :
                mov eax, edx
                imul eax, widths
                add eax, ecx
                mov byte ptr[esi+eax], 1

            nextColumn:
                inc ecx
                cmp ecx, widths
                jl L2

                inc edx

                cmp edx, hights
                jl L1


    ;   Obstacles

    mov ecx, 15

    ; Box=2 & Tree=5

    drawObstacles:
        push ecx
        
        mov eax,18
        call randomrange      ; 0-17
        inc eax               ; 1-18

        mov ebx,eax

        mov eax,18
        call randomrange
        inc eax

        push eax
        imul eax, widths
        add eax, ebx
        

        ; if eax=0 make tree, else Box

        push eax
        mov eax, 2
        call RandomRange
        cmp eax, 0
        pop eax
        je makeTree
        
        mov byte ptr[esi+eax], 2 ; Box
        jmp placed
        
        makeTree:
            mov byte ptr[esi+eax], 5 ; Tree

        placed:
            pop eax
            pop ecx
            dec ecx
            cmp ecx, 0
            jg drawObstacles


    mov ecx, 5

    drawBonuses:

        mov eax,18
        call randomrange
        inc eax

        mov ebx,eax

        mov eax,18
        call randomrange
        inc eax

        imul eax, widths
        add eax, ebx
        
        cmp byte ptr[esi+eax], 0
        jne dontDraw

        mov byte ptr[esi+eax], 3 ; bonus
        
        dontDraw:
            dec ecx
            cmp ecx, 0
            jg drawBonuses


    mov ecx, 3
    spawnPassLoop:
        push ecx
        call drawPassenger
        pop ecx
        loop spawnPassLoop

    ret

initializeBoard ENDP




drawPassenger PROC

    findemptySpace :
        
        mov eax,18
        call randomrange
        inc eax

        mov ebx,eax

        mov eax,18
        call randomrange
        inc eax


        push eax

        imul eax, widths
        add eax, ebx

        ;   grid is 0 / empty ?

        cmp byte ptr[grid+eax], 0
        jne cannotFind

        mov byte ptr[grid+eax], 4
        pop eax
        ret

        cannotFind :
            pop eax
            jmp findemptySpace

drawPassenger ENDP



drawDestiny PROC

    findemptySpace :
    
        mov eax, 18
        call RandomRange

        inc eax
        mov xDestiny, eax
        mov eax, 18
        call RandomRange

        inc eax
        mov yDestiny, eax
        push eax
        imul eax, widths
        add eax, xDestiny
        cmp byte ptr[grid+eax], 0
        jne cannotFind
        
        pop eax
        ret

        cannotFind :
            pop eax
            jmp findemptySpace

drawDestiny ENDP




drawOthercars PROC

    ; car 1
    mov xOther[0], 3
    mov yOther[0], 5
    mov directOther[0], 2 ; Right

    ; car 2
    mov xOther[4], 18
    mov yOther[4], 10
    mov directOther[4], 1 ; Down
     
    ; car 3
    mov xOther[8], 18
    mov yOther[8], 17
    mov directOther[8], 3 ; Left
    ret

drawOthercars ENDP




drawScoreDrop PROC
    call crlf

    mov edx, offset gameScore
    call writestring

    mov eax, score
    call writeint

    mov edx, offset DropsNo
    call writestring

    mov eax, dropCount
    call writedec

    cmp gameMode, 1
    jne SkipTimeDisp

    mov edx, offset timeMsg
    call writestring

    call GetMseconds
    sub eax, startTime    
    
    mov ebx, 1000
    xor edx, edx
    div ebx           
    
    mov ebx, 60
    sub ebx, eax           
    
    cmp ebx, 0
    jge printT
    mov ebx, 0         

    printT:
        mov eax, ebx
        call writedec
    
    mov al, ' '
    call WriteChar
    call WriteChar

    SkipTimeDisp:
        ret

drawScoreDrop ENDP



StartMusic PROC

    INVOKE PlaySoundA, OFFSET songFile, 0, 00020009h
    ret
StartMusic ENDP



StopMusic PROC

    INVOKE PlaySoundA, 0, 0, 0
    ret
StopMusic ENDP





drawBoard PROC
 
    mov dl, 0
    mov dh, 0
    call Gotoxy

    mov esi, offset grid

    mov edx, 0

    L1:                                           ;  l1=row=edx
                                                  ;  l2=col=ecx
        mov ecx, 0

        L2:
            ; 1st priority

            ; if edx==1 && ecx==1 draw P

            cmp ecx, x
            jne drawothercar1

            cmp edx, y
            jne drawothercar1

            mov eax, carcolor
            call SetTextColor

            mov al, carshape
            call WriteChar

            jmp nextColumn
            
                                                     ; if edx==xOther[edi] && ecx==yOther[edi] draw 219
            drawothercar1:

                ; second priority

                push ecx
                push edx
                push ebx

                mov ebx, 3         ;    loop
                mov edi, 0         ;    indexing 

            checkCarLoop:
                                                    ; if edx==xOther[edi] && ecx==yOther[edi] draw 219
                cmp ebx, 0
                je noCarFound
                
                cmp ecx, xOther[edi]
                jne nextCar

                cmp edx, yOther[edi]
                jne nextCar


                mov eax, lightBlue + (black*16)
                call SetTextColor

                mov al, 219
                call WriteChar

                pop ebx
                pop edx
                pop ecx

                jmp nextColumn

                nextCar:
                    add edi, 4          
                    dec ebx
                    jmp checkCarLoop

            noCarFound:
                pop ebx
                pop edx
                pop ecx


            checkDestiny :

                ;     third priority

                cmp isPassen, 1       
                jne decideDrawing
                                             ; if ecx==xDestiny && edx==yOther[edi] draw 219
                cmp ecx, xDestiny
                jne decideDrawing
                
                cmp edx, yDestiny
                jne decideDrawing
                
                mov eax, green + (black*16)
                call SetTextColor
                
                mov al, 'D'
                call WriteChar
                
                jmp nextColumn

            decideDrawing :

                ;   fourth priority

                mov eax, edx
                imul eax,widths
                add eax, ecx

                mov al, [esi+eax]

                cmp al, 0
                je drawRoad

                cmp al, 1
                je drawWall
                
                cmp al, 2
                je drawObstucle
                
                cmp al, 5
                je drawTree
                
                cmp al, 4
                je drawPassengers
                
                cmp al, 3
                je drawBonus
                
            drawRoad :
                mov eax, white + (black*16)
                call SetTextColor
                mov al, ' '
                call WriteChar
                jmp nextColumn

            drawWall :
                mov eax, gray + (black*16)
                call SetTextColor
                mov al, 219
                call WriteChar
                jmp nextColumn

            drawObstucle :
                mov eax, brown + (black*16)
                call SetTextColor
                mov al, 177
                call WriteChar
                jmp nextColumn

            drawTree :
                mov eax, lightGreen + (black*16)
                call SetTextColor
                mov al, 6 
                call WriteChar
                jmp nextColumn

            drawPassengers :
                mov eax, lightCyan + (black*16)
                call SetTextColor
                mov al, 'P'
                call WriteChar
                jmp nextColumn
                
            drawBonus:
                mov eax, lightMagenta + (black*16)
                call SetTextColor
                mov al, '$'
                call WriteChar

            nextColumn :
                inc ecx
                cmp ecx, widths
                jge endCol
                jmp L2

                endCol :
                    call crlf
                    inc edx
                    cmp edx, hights
                    jge endRow
                    
                    jmp L1

        endRow :
            mov eax, white + (black*16)
            call SetTextColor
            ret
drawBoard ENDP


END main