[BITS 32]
[extern kernel_main]

section .text
global start
start:
  call kernel_main
  jmp hang

hang:
  hlt
  jmp hang