[BITS 32]
[org 0x10000]

mov byte [0xB8000], 'T'        ; start of VGA buffer
mov byte [0xB8001], 0x2F       ; start of VGA buffer

hang:
  hlt
  jmp hang