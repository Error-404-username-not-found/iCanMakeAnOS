void clear_vga_buffer(void);

void kernel_main() {
  char* vga = 0xB8000;

  *(vga) = 'T';
  *(vga+1) = 0x2F;

  clear_vga_buffer();
}

void clear_vga_buffer() {
  char* vga = 0xB8000;
  for (int i=0; i<80*25; i++) {
    *(vga+(i*2)) = 0;
    *(vga+(i*2)+1) = 0x07;
  }
}

// int k_print(char* msg) {
//   int a, b
// }

// void take_inp() {
//   get keystrokes
//   store keystrokes from 0xabcd to 0xabcd+no of keystrokes*2
//   char* msg = 0xabcd
//   k_print(msg)
// }