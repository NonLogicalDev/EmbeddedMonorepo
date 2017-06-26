
build/Blink.elf:     file format elf32-avr


Disassembly of section .text:

00000000 <loop>:
  }
}

// This runs infinitely
void loop() {
    PORTB |= _BV(PORTB5);
   0:	2d 9a       	sbi	0x05, 5	; 5
	#else
		//round up by default
		__ticks_dc = (uint32_t)(ceil(fabs(__tmp)));
	#endif

	__builtin_avr_delay_cycles(__ticks_dc);
   2:	2f ef       	ldi	r18, 0xFF	; 255
   4:	89 e6       	ldi	r24, 0x69	; 105
   6:	98 e1       	ldi	r25, 0x18	; 24
   8:	21 50       	subi	r18, 0x01	; 1
   a:	80 40       	sbci	r24, 0x00	; 0
   c:	90 40       	sbci	r25, 0x00	; 0
   e:	e1 f7       	brne	.-8      	; 0x8 <__zero_reg__+0x7>
  10:	00 c0       	rjmp	.+0      	; 0x12 <__zero_reg__+0x11>
  12:	00 00       	nop
    _delay_ms(500);

    PORTB &= ~_BV(PORTB5);
  14:	2d 98       	cbi	0x05, 5	; 5
  16:	2f ef       	ldi	r18, 0xFF	; 255
  18:	89 e6       	ldi	r24, 0x69	; 105
  1a:	98 e1       	ldi	r25, 0x18	; 24
  1c:	21 50       	subi	r18, 0x01	; 1
  1e:	80 40       	sbci	r24, 0x00	; 0
  20:	90 40       	sbci	r25, 0x00	; 0
  22:	e1 f7       	brne	.-8      	; 0x1c <__zero_reg__+0x1b>
  24:	00 c0       	rjmp	.+0      	; 0x26 <__zero_reg__+0x25>
  26:	00 00       	nop
  28:	08 95       	ret

0000002a <init>:
    _delay_ms(500);
}

// This initialises AVR
void init() { 
  DDRB |= _BV(DDB5);
  2a:	25 9a       	sbi	0x04, 5	; 4
  2c:	08 95       	ret

0000002e <main>:

void init();
void loop();

int main(void) {
  init();
  2e:	0e 94 15 00 	call	0x2a	; 0x2a <init>
  for(;;) {
    loop();
  32:	0e 94 00 00 	call	0	; 0x0 <loop>
  36:	fd cf       	rjmp	.-6      	; 0x32 <main+0x4>
