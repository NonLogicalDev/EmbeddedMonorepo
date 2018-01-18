cmake_minimum_required(VERSION 3.6)
get_filename_component(PROJECT_PATH "../.." REALPATH)

include("${PROJECT_PATH}/Toolchain/Platform/AVR.cmake")
include("${PROJECT_PATH}/Toolchain/Arduino.cmake")
include("${PROJECT_PATH}/Toolchain/helpers.cmake")

# (SETTINGS): ------------------------------------------------------------------
# Set up Project settings
set(PROJECT_NAME LEDStrip)


# Board Settings
set(PROJECT_CPU atmega328p)
set(PROJECT_FREQ 16000000UL)

# Library Path
set(LIB_PATH "${PROJECT_PATH}/Libs")

# (DEFINE PROJECT): ------------------------------------------------------------

# Set up the project
project(${PROJECT_NAME})
init_arduino_core()

# (TARGETS) --------------------------------------------------------------------

# >> Core Arduino library
set(CORE_LIB_NAME arduino)
set(${CORE_LIB_NAME}_SRCS ${ARDUINO_SRCS})
set(${CORE_LIB_NAME}_INCLUDES ${ARDUINO_INCLUDES})
make_avr_library(${CORE_LIB_NAME})

# >> Main Firmware
set(FW_NAME ${PROJECT_NAME})
set(${FW_NAME}_LIBS ${CORE_LIB_NAME} ${ARDUINO_LIBS})

set(${FW_NAME}_SRCS src/main.cpp src/App.cpp)
set(${FW_NAME}_INCLUDES ${ARDUINO_INCLUDES})

collect_sources(${FW_NAME}_INCLUDES ${FW_NAME}_SRCS "${LIB_PATH}/Bounce2")
collect_sources(${FW_NAME}_INCLUDES ${FW_NAME}_SRCS "${LIB_PATH}/TimerOne")
collect_sources(${FW_NAME}_INCLUDES ${FW_NAME}_SRCS "${LIB_PATH}/LPD6803")

make_avr_firmware(${FW_NAME})
