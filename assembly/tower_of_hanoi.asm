section .data
  prompt db 'Please enter the number of disks (1 to 99):', 0
  move_msg1 db 'Move disk ', 0
  move_msg2 db ' from tower ', 0
  move_msg3 db ' to tower ', 0
  success_msg db 'Done!', 0
  invalid_input db 'Invalid input, please try again.', 0
  tower_A db 'A', 0
  tower_B db 'B', 0
  tower_C db 'C', 0
  newline db 10

section .bss
  input_buffer resb 3   ;Buffer to store user input (2 digits max + newline)
  num_disks resb 1      ;Storage for the parsed number of disks
  temp_buffer resb 2    ;Temporary buffer for integer-to-string conversion

section .text
  global _start

_start:
  ;Display the prompt to the user asking for the number of disks
  mov ecx, prompt
  call print_string

  ;Read user input (up to 2 characters + newline)
  mov ecx, input_buffer
  call read_input

  ;Validate user input to ensure it is between 1 and 99
  call validate_input

  ;Convert the string input into an integer and store it in num_disks
  call string_to_int

  ;Retrieve the parsed number of disks into the EAX register
  movzx eax, byte [num_disks] ;Store number of disks in EAX, zero-extend to avoid errors
  mov [num_disks], al

  ;Solve Tower of Hanoi
  mov dl, [tower_A]
  mov dh, [tower_B]
  mov bl, [tower_C]
  movzx ecx, byte [num_disks] ;Ensure ECX is properly zero-extended
  call hanoi

  ;Print success message
  mov ecx, success_msg
  call print_string

  ;Exit program
  mov eax, 1
  xor ebx, ebx
  int 0x80

;Tower of Hanoi recursive function
hanoi:
  ;Save registers to preserve their values during recursion
  push ebx
  push edx
  push ecx

  cmp cl, 1
  je .base_case

  ;Recursive case: Move n-1 disks from source to auxiliary
  dec cl
  push dh
  mov dh, bl
  call hanoi
  pop dh
  inc cl

  ;Move nth disk directly from source to destination
  mov ecx, move_msg1
  call print_string

  movzx eax, cl
  call print_int

  mov ecx, move_msg2
  call print_string

  mov al, dl
  call print_char

  mov ecx, move_msg3
  call print_string

  mov al, dh
  call print_char

  mov ecx, newline
  call print_char

  ;Recursive case: Move n-1 disks from auxiliary to destination
  dec cl
  push dl
  mov dl, dh
  call hanoi
  pop dl
  inc cl
.base_case:
  ;Handle single disk move
  mov ecx, move_msg1
  call print_string

  movzx eax, cl
  call print_int

  mov ecx, move_msg2
  call print_string

  mov al, dl
  call print_char

  mov ecx, move_msg3
  call print_string

  mov al, dh
  call print_char

  mov ecx, newline
  call print_char

  ;Restore registers and return
  pop ecx
  pop edx
  pop ebx
  ret

validate_input:
  ;Check if the first character is between '1' and '9'
  mov al, [input_buffer]
  cmp al, '1'
  jl .invalid
  cmp al, '9'
  jg .invalid

  ;Check if the second character is between '0' and '9'
  mov al, [input_buffer + 1]
  cmp al, '0'
  jl .invalid
  cmp al, '9'
  jg .invalid
  ret
.invalid:
  mov ecx, invalid_input
  call print_string
  jmp _start


string_to_int:
  ;Convert string input to integer
  mov al, [input_buffer]
  sub al, '0'
  mov [num_disks], al
  ret

print_string:
  ;Print null-terminated string
  mov eax, 4
  mov ebx, 1
  lea esi, [ecx]
.print_loop:
  lodsb ;Load byte at [esi] into AL and increment ESI
  test al, al ;Check if AL is null
  je .done
  mov eax, 4
  mov ebx, 1
  lea ecx, [esi - 1]
  mov edx, 1
  int 0x80
  jmp .print_loop
.done:
  ret

read_input:
  ;Read user input
  mov eax, 3
  mov ebx, 0
  mov ecx, input_buffer
  mov edx, 3
  int 0x80
  ret

print_char:
  ;Print a single character
  mov eax, 4
  mov ebx, 1
  lea ecx, [esp+4]
  mov edx, 1
  int 0x80
  ret

print_int:
  ;Convert integer to string and print
  lea edi, [temp_buffer + 2]
  mov ecx, 10
  xor edx, edx
.convert_loop:
  div ecx
  add dl, '0'
  dec edi
  mov [edi], dl
  test eax, eax
  jnz .convert_loop

  mov eax, 4
  mov ebx, 1
  lea ecx, [edi]
  lea edx, [temp_buffer + 2]
  sub edx, edi
  int 0x80
  ret
