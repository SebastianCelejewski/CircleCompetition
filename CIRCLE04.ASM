.386
code segment use16
assume cs:code, ds:code, es:code

; Circle 04: real circle, not a disk

org 100h

start:
       push 0a000h
       pop es

       mov ax,13h
       int 10h

       ; BX - y coordinate
       ; CX - x coordinate
draw:
       mov bx, 100h
       mov di, 0
outer_loop:
       mov cx, 100h

inner_loop:
       call calculate_colour
       call calculate_offset

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
       jne wait_for_key

       mov ah, 07h
       int 21h

       mov ax,03h
       int 10h

       mov ax,4c00h
       int 21h

; input: BX, CX - coordinates
; output: dl - char to be displayed
calculate_colour:
       push ax
       push bx
       push cx

       sub cx, 0a0h
       sub bx, 60h

       mov ax, cx
       mul ax
       mov cx, ax

       mov ax, bx
       mul ax
       add cx, ax

       cmp cx, 800h
       jbe inside_disk
       mov dl, 0h
       jmp exit

inside_disk:
       cmp cx, 780h
       jbe too_low
       mov dl, colour
       jmp exit

too_low:
       mov dl, 0h

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
       mov bx, 320
       mul bx

       add ax, cx
       mov di, ax

       pop dx
       pop bx
       pop ax
       ret

colour db 02h

code ends
end start