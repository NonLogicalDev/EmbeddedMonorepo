cmake_minimum_required(VERSION 3.6)
set(EMBEDDED_TOOLHAIN_PATH "../..")
set(CMAKE_TOOLCHAIN_FILE "${EMBEDDED_TOOLHAIN_PATH}/Toolchain/Platform/AVR.cmake")

set(PROJECT_NAME Blink)
project(${PROJECT_NAME})

# Core library
set(CORE_LIB_NAME atmega328pCore)
set(${CORE_LIB_NAME}_SRCS src/main.c)
set(${CORE_LIB_NAME}_CPU  atmega328p)
set(${CORE_LIB_NAME}_FREQ 16000000UL)

make_avr_library(${CORE_LIB_NAME})

# Generating the firmware
set(FW_NAME ${PROJECT_NAME})

set(${FW_NAME}_SRCS src/blink.c)
set(${FW_NAME}_CPU  atmega328p)
set(${FW_NAME}_FREQ 16000000UL)
set(${FW_NAME}_LIBS ${CORE_LIB_NAME})

make_avr_firmware(${FW_NAME})
