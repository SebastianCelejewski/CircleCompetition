.386
code segment use16
assume cs:code, ds:code, es:code

; Circle 01: simple circle in text mode

org 100h

start:

       ; BX - y coordinate
       ; CX - x coordinate

       mov bx, 30
outer_loop:
       mov cx, 30

inner_loop:
       call calculate_colour

       mov ah,06h
       int 21h
       int 21h
       dec cx
       cmp cx,0
       jne inner_loop

       mov dl,0ah
       int 21h

       mov dl,0dh
       int 21h

       dec bx
       cmp bx,0
       jne outer_loop

       mov ax,4c00h
       int 21h

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
       mov dl, '*'
exit:
       pop cx
       pop bx
       pop ax

       ret

code ends
end start