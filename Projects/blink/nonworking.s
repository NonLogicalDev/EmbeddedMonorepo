
build/Blink.elf:     file format elf32-avr


Disassembly of section .text:

00000000 <init>:
  }
}

// This initialises AVR
void init() { 
  DDRB |= _BV(DDB5);
   0:	25 9a       	sbi	0x04, 5	; 4
   2:	08 95       	ret

00000004 <loop>:
}

// This runs infinitely
void loop() {
    PORTB |= _BV(PORTB5);
   4:	2d 9a       	sbi	0x05, 5	; 5
	#else
		//round up by default
		__ticks_dc = (uint32_t)(ceil(fabs(__tmp)));
	#endif

	__builtin_avr_delay_cycles(__ticks_dc);
   6:	2f ef       	ldi	r18, 0xFF	; 255
   8:	89 e6       	ldi	r24, 0x69	; 105
   a:	98 e1       	ldi	r25, 0x18	; 24
   c:	21 50       	subi	r18, 0x01	; 1
   e:	80 40       	sbci	r24, 0x00	; 0
  10:	90 40       	sbci	r25, 0x00	; 0
  12:	e1 f7       	brne	.-8      	; 0xc <loop+0x8>
  14:	00 c0       	rjmp	.+0      	; 0x16 <loop+0x12>
  16:	00 00       	nop
    _delay_ms(500);

    PORTB &= ~_BV(PORTB5);
  18:	2d 98       	cbi	0x05, 5	; 5
  1a:	2f ef       	ldi	r18, 0xFF	; 255
  1c:	89 e6       	ldi	r24, 0x69	; 105
  1e:	98 e1       	ldi	r25, 0x18	; 24
  20:	21 50       	subi	r18, 0x01	; 1
  22:	80 40       	sbci	r24, 0x00	; 0
  24:	90 40       	sbci	r25, 0x00	; 0
  26:	e1 f7       	brne	.-8      	; 0x20 <loop+0x1c>
  28:	00 c0       	rjmp	.+0      	; 0x2a <loop+0x26>
  2a:	00 00       	nop
  2c:	08 95       	ret

0000002e <main>:

void init();
void loop();

int main(void) {
  init();
  2e:	0e 94 00 00 	call	0	; 0x0 <init>
  for(;;) {
    loop();
  32:	0e 94 02 00 	call	0x4	; 0x4 <loop>
  36:	fd cf       	rjmp	.-6      	; 0x32 <main+0x4>
