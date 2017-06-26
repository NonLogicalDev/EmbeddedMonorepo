build:
	rm -rf build
	mkdir build
	cd build && cmake ..
	make -C build

upload:
	avrdude -V -c arduino -b 57600 -P /dev/tty.usbserial-A600IAYT -p atmega328p -U flash:w:build/Blink.hex


.PHONY: build
