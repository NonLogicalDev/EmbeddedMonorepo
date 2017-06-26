PNAME=LEDStrip
UART_DEV=/dev/tty.usbserial-A600IAYT

init:
	rm -rf build
	mkdir build
	cd build && cmake ..

build:
	make -C build

rebuild: init build

upload:
	avrdude -V -c arduino -b 57600 -P ${UART_DEV} -p atmega328p -U flash:w:build/${PNAME}.hex:i
	avrdude -V -c arduino -b 57600 -P ${UART_DEV} -p atmega328p -U eeprom:w:build/${PNAME}.eep:i


.PHONY: build
