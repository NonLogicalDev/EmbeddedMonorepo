PNAME=LEDStrip
UART_DEV=/dev/tty.usbserial-A600IAYT
MCU=atmega328p
BAUD_RATE=57600

init:
	rm -rf build
	mkdir build
	cd build && cmake --verbose ..

build:
	make -C build VERBOSE=1

rebuild: init build

upload:
	avrdude -V -c arduino -b ${BAUD_RATE} -P ${UART_DEV} -p ${MCU} -U flash:w:build/${PNAME}.hex:i
	avrdude -V -c arduino -b ${BAUD_RATE} -P ${UART_DEV} -p ${MCU} -U eeprom:w:build/${PNAME}.eep:i

.PHONY: build
