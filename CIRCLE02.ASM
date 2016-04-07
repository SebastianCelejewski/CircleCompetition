.386
code segment use16
assume cs:code, ds:code, es:code

; Circle 02: animated circle in text mode usinb 0b0000h memory

org 100h

start:
       push 0b800h
       pop es

       call cls

       ; BX - y coordinate
       ; CX - x coordinate
draw:

       mov bx, 30
       mov di, 0
outer_loop:
       mov cx, 30

inner_loop:
       call calculate_colour

       call calculate_offset

       mov es:[di], dl
       inc di
       inc di
       mov es:[di], dl

       dec cx
       cmp cx,0
       jne inner_loop

       dec bx
       cmp bx,0
       jne outer_loop

wait_for_key:
       mov ah, 0bh
       int 21h

       cmp al, 0ffh
       jne draw

       mov ah, 07h
       int 21h

       mov ax,4c00h
       int 21h

cls:
;        mov cx, 160*80*2
        mov cx, 0a00h
        mov ax, 00800h
        mov di, 0
cls_loop:
        mov es:[di], ax
        dec cx
        inc di
        inc di
        cmp cx,0
        jne cls_loop

        ret

; input: BX, CX - coordinates
; output: dl - char to be displayed
calculate_colour:
       push ax
       push bx
       push cx

       sub cx, 10h
       sub bx, 0ch

       mov ax, cx
       mul ax
       mov cx, ax

       mov ax, bx
       mul ax
       add cx, ax

       cmp cx, 60h
       jbe set
       mov dl, ' '
       jmp exit
set:
       mov dl, brush
       inc dl
       mov brush, dl
exit:
       pop cx
       pop bx
       pop ax

       ret

; input: BX, CX - coordinates
; output: DI - offset in video memory
calculate_offset:
       push ax
       push bx
       push dx

       mov ax, bx
       mov bx, 160
       mul bx

       add ax, cx
       add ax, cx
       add ax, cx
       add ax, cx

       mov di, ax

       pop dx
       pop bx
       pop ax
       ret

brush db 'a'

code ends
end start