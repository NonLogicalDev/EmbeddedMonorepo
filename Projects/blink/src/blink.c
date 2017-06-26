#include <avr/io.h>
#include <util/delay.h>

// This initialises AVR
void init() { 
  DDRB |= _BV(DDB5);
}

// This runs infinitely
void loop() {
    PORTB |= _BV(PORTB5);
    _delay_ms(500);

    PORTB &= ~_BV(PORTB5);
    _delay_ms(500);
}
