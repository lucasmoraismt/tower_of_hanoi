section .data
  prompt db "Enter a two-digit number (01 to 99): ", 0
  invalid db "Invalid input. Please enter between 01-99.", 0
  template db "Move disk ** from tower X to tower Y", 10, 0

section .bss
  input resb 4
  num resb 1

section .text
  global _start

_start:
  mov bp, sp

start_loop:
  ;Print prompt
  mov eax, 4
  mov ebx, 1
  mov ecx, prompt
  mov edx, 37
  int 0x80

  ;Read input
  mov eax, 3
  mov ebx, 0
  mov ecx, input
  mov edx, 4
  int 0x80

  ;Validate input
  cmp byte [input+2], 0xA
  jne invalid_input
  mov al, [input]
  sub al, '0'
  cmp al, 0
  jl invalid_input
  cmp al, 9
  jg invalid_input
  mov bl, [input+1]
  sub bl, '0'
  cmp bl, 0
  jl invalid_input
  cmp bl, 9
  jg invalid_input
  mov ah, 10
  mul ah
  add al, bl
  cmp al, 1
  jl invalid_input
  cmp al, 99
  jg invalid_input
  mov [num], al

  ;Call Hanoi
  movzx ax, byte [num]
  mov bx, 'A'
  mov cx, 'C'
  mov dx, 'B'
  call hanoi

  ;Exit
  mov eax, 1
  xor ebx, ebx
  int 0x80

invalid_input:
  mov eax, 4
  mov ebx, 1
  mov ecx, invalid
  mov edx, 55
  int 0x80
  jmp start_loop

hanoi:
  cmp al, 0
  je .done

  push ax
  push bx
  push cx
  push dx

  dec al
  xchg cx, dx
  call hanoi

  pop dx
  pop cx
  pop bx
  pop ax

  push ax
  push bx
  push cx
  push dx
  call print_move
  pop dx
  pop cx
  pop bx
  pop ax

  push ax
  push bx
  push cx
  push dx
  dec al
  xchg bx, dx
  call hanoi
  pop dx
  pop cx
  pop bx
  pop ax

.done:
  ret

print_move:
  ;Get current disk number (ax = disk#)
  mov cx, ax

  ;Convert disk number to ASCII
  mov al, cl
  mov ah, 0
  mov bl, 10
  div bl
  add ax, 0x3030

  ;Handle single-digit numbers
  cmp al, '0'
  jne .two_digit
  mov al, ' '  ;Replace leading zero with space

.two_digit:
  mov [template+10], al
  mov [template+11], ah

  ;Get towers from stack (BX=source, CX=dest)
  ;Stack layout: [ret][ax][bx][cx][dx]
  mov ax, [esp+6]  ;Dest tower (BX)
  mov [template+35], al
  mov ax, [esp+8]  ;Source tower (CX)
  mov [template+24], al

  ;Print template
  pusha
  mov eax, 4
  mov ebx, 1
  mov ecx, template
  mov edx, 37
  int 0x80
  popa
  ret
