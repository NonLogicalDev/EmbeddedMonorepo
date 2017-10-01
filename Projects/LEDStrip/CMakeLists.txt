cmake_minimum_required(VERSION 3.6)
get_filename_component(EMBEDDED_TOOLHAIN_PATH "../.." REALPATH)

set(LIB_PATH "${EMBEDDED_TOOLHAIN_PATH}/Libs")
include("${EMBEDDED_TOOLHAIN_PATH}/Toolchain/helpers.cmake")
include("${EMBEDDED_TOOLHAIN_PATH}/Toolchain/Platform/AVR.cmake")

# (SETTINGS): ------------------------------------------------------------------

# Set up Project settings
set(PROJECT_NAME LEDStrip)
set(PROJECT_CPU atmega328p)
set(PROJECT_FREQ 16000000UL)

# Set up Arduino settings
set(ARDUINO_ROOT "${EMBEDDED_TOOLHAIN_PATH}/Toolchain/Core/arduino/avr")

# (DEFINE PROJECT): ------------------------------------------------------------

# Set up the project
project(${PROJECT_NAME})

# (FIND ARDUINO LIBS): ---------------------------------------------------------

set(ARDUINO_INCLUDES
    "${ARDUINO_ROOT}/cores/arduino"
    "${ARDUINO_ROOT}/variants/eightanaloginputs")
file(GLOB ARDUINO_SRCS
    ${ARDUINO_ROOT}/cores/arduino/*.S
    ${ARDUINO_ROOT}/cores/arduino/*.c
    ${ARDUINO_ROOT}/cores/arduino/*.cpp)

file(GLOB ARDUINO_LIBS "${ARDUINO_ROOT}/libraries/*")

foreach(ARDUINO_LIB IN ITEMS ${ARDUINO_LIBS})
  collect_sources(ARDUINO_INCLUDES ARDUINO_SRCS
      "${ARDUINO_LIB}/src" "*.c" "*.cpp" "*.S")
endforeach(ARDUINO_LIB)

# (TARGETS) --------------------------------------------------------------------

# >> Core Arduino library
set(CORE_LIB_NAME arduino)
set(${CORE_LIB_NAME}_CPU  ${PROJECT_CPU})
set(${CORE_LIB_NAME}_FREQ ${PROJECT_FREQ})

set(${CORE_LIB_NAME}_SRCS ${ARDUINO_SRCS})
set(${CORE_LIB_NAME}_INCLUDES ${ARDUINO_INCLUDES})

set(${CORE_LIB_NAME}_DEFINES "ARDUINO=300")

make_avr_library(${CORE_LIB_NAME})

# >> Generating the firmware
set(FW_NAME ${PROJECT_NAME})
set(${FW_NAME}_CPU  ${PROJECT_CPU})
set(${FW_NAME}_FREQ ${PROJECT_FREQ})

set(${FW_NAME}_SRCS
    src/main.cpp
    src/App.cpp)

set(${FW_NAME}_INCLUDES
    ${ARDUINO_INCLUDES})

set(${FW_NAME}_DEFINES
    "ARDUINO=10612"
    "ARDUINO_AVR_UNO"
    "ARDUINO_ARCH_AVR")

collect_sources(${FW_NAME}_INCLUDES ${FW_NAME}_SRCS
    "${LIB_PATH}/Bounce2" "*.c" "*.cpp")
collect_sources(${FW_NAME}_INCLUDES ${FW_NAME}_SRCS
    "${LIB_PATH}/TimerOne" "*.c" "*.cpp")
collect_sources(${FW_NAME}_INCLUDES ${FW_NAME}_SRCS
    "${LIB_PATH}/LPD6803" "*.c" "*.cpp")

message("${${FW_NAME}_SRCS}")

set(${FW_NAME}_LIBS ${CORE_LIB_NAME})

make_avr_firmware(${FW_NAME})
