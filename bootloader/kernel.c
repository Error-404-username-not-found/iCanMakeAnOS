void kernel_main() {
  char* vga = 0xB8000;

  *(vga) = 'T';
  *(vga+1) = 0x2F;
}