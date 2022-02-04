; Printing 3 rectangles
; Colors are purple, green, white

[org 0x100]
jmp start

clrscr: 	
        push es
		    push ax
        push di 

        mov ax, 0xb800
        mov es, ax 	; point es to video base
        mov di, 0 	; point di to top left column

nextloc: 	
        mov word [es:di], 0x0720 	; clear next char on screen
        add di, 2 			; move to next screen location
        cmp di, 4000 			; has the whole screen cleared
        jne nextloc 			; if no clear next position

        pop di
        pop ax
        pop es
        ret 

sleep:		
        push cx
		    mov cx, 3
delay_loop1:
      	push cx
		    mov cx, 0xFFFF
delay_loop2:
        loop delay_loop2
        pop cx
        loop delay_loop1
        pop cx
        ret

printRectangle:	
        push bp
        mov bp, sp
        push es
        push ax
        push cx
        push si
        push di

        mov ax, 0xb800
        mov es, ax 		; point es to video base

        mov al, 80 		; load al with columns per row
        mul byte [bp+12] 	; multiply with row number
        add ax, [bp+10] 	; add col
        shl ax, 1 		; turn into byte offset
        mov di, ax 		; point di to required location
        mov ah, [bp+4] 		; load attribute in ah
        mov cx, [bp+6]
        sub cx, [bp+10]

topLine:	
        mov al, 0x2D 		; ASCII of '-'
        mov [es:di], ax 	; show this char on screen
        add di, 2 		; move to next screen location 
        call sleep;
        loop topLine		; repeat the operation cx times

        mov cx, [bp+8]
        sub cx, [bp+12]
        add di, 160

rightLine:	
        mov al, 0x7c 	             ; ASCII of '|'
        mov [es:di], ax 	             ; show this char on screen
        add di, 160 	             ; move to next screen location 		
        call sleep;
        loop rightLine	             ; repeat the operation cx times

        mov cx, [bp+6]
        sub cx, [bp+10]
        sub di, 2

bottomLine:	
        mov al, 0x2D 		; ASCII of '-'
        mov [es:di], ax 	; show this char on screen
        sub di, 2 		; move to next screen location 
        call sleep;
        loop bottomLine		; repeat the operation cx times

        mov cx, [bp+8]
        sub cx, [bp+12]
        sub di, 160

leftLine:	
        mov al, 0x7c 		; ASCII of '|'
        mov [es:di], ax 	; show this char on screen
        sub di, 160 		; move to next screen location 		
        call sleep;
        loop leftLine		; repeat the operation cx times

        pop di
        pop si
        pop cx
        pop ax
        pop es
        pop bp
        ret 10
		
start: 		
        call clrscr     ; call the clrscr subroutine	
        mov ax, 2
        push ax 		; push top
        mov ax, 10
        push ax 		; push left
        mov ax, 20
        push ax 		; push bottom
        mov ax, 60
        push ax 		; push right number

        mov ax, 0x55		; Purple color
        push ax 		; push attribute
        call printRectangle	; call the printstr subroutine

        call clrscr

        mov ax, 2
        push ax 		; push top
        mov ax, 10
        push ax 		; push left

        mov ax, 15
        push ax 		; push bottom
        mov ax, 25
        push ax 		; push right number

        mov ax, 0x22    ; Green color
        push ax 		; push attribute
        call printRectangle	; call the printstr subroutine


        call clrscr
        mov ax, 1
        push ax 		; push top
        mov ax, 10
        push ax 		; push left

        mov ax, 12
        push ax 		; push bottom
        mov ax, 25
        push ax 		; push right number

        mov ax, 0x77             ; White color
        push ax 		             ; push attribute
        call printRectangle	     ; call the printstr subroutine

        mov ax,0x4c00
        int 0x21                 ; end the programme
	
