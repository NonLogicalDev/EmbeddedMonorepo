cmake_minimum_required(VERSION 3.6)
include(CMakeParseArguments)

######################################################################
## Platform Definition

set(CMAKE_SYSTEM_NAME Generic)
set(_CMAKE_TOOLCHAIN_PREFIX avr-)


set(CMAKE_C_COMPILER avr-gcc)
set(CMAKE_CXX_COMPILER avr-g++)
set(CMAKE_ASM_COMPILER avr-gcc)

set(CMAKE_AR avr-gcc-ar CACHE STRING "")

enable_language(ASM)
set(ASM_DIALECT "-GAS")


######################################################################
## Macros

function(MAKE_AVR_FIRMWARE TARGET_NAME)
  message("Generating AVR Firmware ${TARGET_NAME}")
  compile_avr_firmware(${TARGET_NAME})
  prepare_firmware_sections(${TARGET_NAME})
endfunction()

function(MAKE_AVR_LIBRARY TARGET_NAME)
  message("Generating AVR Library ${TARGET_NAME}")
  compile_avr_library(${TARGET_NAME})
endfunction()

# Compile and link the firmware produce an elf, eep and hex file
function(compile_avr_firmware TARGET_NAME)
  # Gathering parameters
  set(ALL_SRCS ${${TARGET_NAME}_SRCS})
  set(ALL_LIBS ${${TARGET_NAME}_LIBS})
  set(ALL_INCLUDES ${${TARGET_NAME}_INCLUDES})
  set(ALL_DEFINES ${${TARGET_NAME}_DEFINES})
  set(TARGET_CPU ${${TARGET_NAME}_CPU})
  set(TARGET_FREQ ${${TARGET_NAME}_FREQ})

  # Creating an executable
  add_executable(${TARGET_NAME} ${ALL_SRCS})
  set_target_properties(${TARGET_NAME} PROPERTIES
    SUFFIX ".elf"
    COMPILE_DEFINITIONS "F_CPU=${TARGET_FREQ};${ALL_DEFINES} "
    COMPILE_FLAGS "-mmcu=${TARGET_CPU} "
    LINK_FLAGS "-mmcu=${TARGET_CPU} ")

  # Adding folders to search for includes
  target_include_directories(${TARGET_NAME} PUBLIC ${ALL_INCLUDES})
  # target_include_directories(${TARGET_NAME} PRIVATE ${ALL_INCLUDES})
  # target_include_directories(${TARGET_NAME} INTERFACE ${ALL_INCLUDES})

  # Linking executable with libraries
  target_link_libraries(${TARGET_NAME} ${ALL_LIBS})
endfunction()
  set(TARGET_FREQ ${${TARGET_NAME}_FREQ})

# Compile and link the library and produce the libarchive file
function(compile_avr_library TARGET_NAME)
  # Gathering parameters
  set(ALL_SRCS ${${TARGET_NAME}_SRCS})
  set(ALL_LIBS ${${TARGET_NAME}_LIBS})
  set(ALL_INCLUDES ${${TARGET_NAME}_INCLUDES})
  set(ALL_DEFINES ${${TARGET_NAME}_DEFINES})
  set(TARGET_CPU ${${TARGET_NAME}_CPU})
  set(TARGET_FREQ ${${TARGET_NAME}_FREQ})

  # Creating a library
  add_library(${TARGET_NAME} ${ALL_SRCS})
  set_target_properties(${TARGET_NAME} PROPERTIES
    COMPILE_DEFINITIONS "F_CPU=${TARGET_FREQ};${ALL_DEFINES} "
    COMPILE_FLAGS "-mmcu=${TARGET_CPU} "
    LINK_FLAGS "-mmcu=${TARGET_CPU} ")

  # Adding folders to search for includes
  target_include_directories(${TARGET_NAME} PUBLIC ${ALL_INCLUDES})

  # Linking executable with libraries
  target_link_libraries(${TARGET_NAME} ${ALL_LIBS})
endfunction()

# Take the object file and split it into two sections
# 1. EEPROM Section
# 2. Actual Firmware (Everything but EEPROM)
function(prepare_firmware_sections TARGET_NAME)
  # Find the object copy util if is not already specified
  if(NOT CMAKE_OBJCOPY)
    find_program(AVROBJCOPY_PROGRAM avr-objcopy)
    set(CMAKE_OBJCOPY ${AVROBJCOPY_PROGRAM})
  endif(NOT CMAKE_OBJCOPY)

  # Adapt to runtime output directory setting
  if(NOT RUNTIME_OUTPUT_DIRECTORY)
    set(RUNTIME_OUTPUT_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR})
  endif()
  set(TARGET_PATH ${RUNTIME_OUTPUT_DIRECTORY}/${TARGET_NAME})

  # Convert firmware image to ASCII HEX format (Only eeprom section)
  add_custom_command(TARGET ${TARGET_NAME} POST_BUILD
    COMMAND ${CMAKE_OBJCOPY}
    ARGS    ${AVR_OBJCOPY_FLAGS_EEP}
            ${TARGET_PATH}.elf
            ${TARGET_PATH}.eep
    COMMENT "Generating EEP image"
    VERBATIM)

  # Convert firmware image to ASCII HEX format
  add_custom_command(TARGET ${TARGET_NAME} POST_BUILD
    COMMAND ${CMAKE_OBJCOPY}
    ARGS    ${AVR_OBJCOPY_FLAGS_HEX}
            ${TARGET_PATH}.elf
            ${TARGET_PATH}.hex
    COMMENT "Generating HEX image"
    VERBATIM)
endfunction()

######################################################################
## Flags

# ASM Flags                                        
#=====================================================================

set(CMAKE_ASM_FLAGS              "${CFLAGS} -x assembler-with-cpp")

# C Flags                                        
#=====================================================================
if(NOT DEFINED AVR_C_FLAGS)
  set(AVR_C_FLAGS "-std=gnu11 -ffunction-sections -fdata-sections -MMD  -fno-fat-lto-objects")
endif()


set(CMAKE_C_FLAGS                "-g -Os ${AVR_C_FLAGS}" CACHE STRING "")
# set(CMAKE_C_FLAGS_DEBUG          "-g              ${AVR_C_FLAGS}" CACHE STRING "")
# set(CMAKE_C_FLAGS_MINSIZEREL     "-Os -DNDEBUG    ${AVR_C_FLAGS}" CACHE STRING "")
# set(CMAKE_C_FLAGS_RELEASE        "-Os -DNDEBUG -w ${AVR_C_FLAGS}" CACHE STRING "")
# set(CMAKE_C_FLAGS_RELWITHDEBINFO "-Os -g       -w ${AVR_C_FLAGS}" CACHE STRING "")

# C++ Flags                                       
#=====================================================================
if(NOT DEFINED AVR_CXX_FLAGS)
  set(AVR_CXX_FLAGS "-std=gnu++11 -fpermissive -fno-exceptions -ffunction-sections -fdata-sections -fno-threadsafe-statics -MMD ")
endif()

set(CMAKE_CXX_FLAGS                  "-g -Os       ${AVR_CXX_FLAGS}" CACHE STRING "")
# set(CMAKE_CXX_FLAGS_DEBUG          "-g           ${AVR_CXX_FLAGS}" CACHE STRING "")
# set(CMAKE_CXX_FLAGS_MINSIZEREL     "-Os -DNDEBUG ${AVR_CXX_FLAGS}" CACHE STRING "")
# set(CMAKE_CXX_FLAGS_RELEASE        "-Os -DNDEBUG ${AVR_CXX_FLAGS}" CACHE STRING "")
# set(CMAKE_CXX_FLAGS_RELWITHDEBINFO "-Os -g       ${AVR_CXX_FLAGS}" CACHE STRING "")

# Executable Linker Flags
#=====================================================================
if(NOT DEFINED AVR_EXE_LINKER_FLAGS)
  set(AVR_EXE_LINKER_FLAGS "-fuse-linker-plugin -Wl,--gc-sections")
  # set(AVR_EXE_LINKER_FLAGS "-lc -lm")
  # set(AVR_EXE_LINKER_FLAGS "-lm")
  # set(AVR_EXE_LINKER_FLAGS "-Wl,--gc-sections,--print-gc-sections -lm -lc")
  # set(AVR_EXE_LINKER_FLAGS "-Wl,--gc-sections,--print-gc-sections -lm -lc")
endif()

set(CMAKE_EXE_LINKER_FLAGS                  "${AVR_EXE_LINKER_FLAGS}" CACHE STRING "")
# set(CMAKE_EXE_LINKER_FLAGS_DEBUG          "${AVR_EXE_LINKER_FLAGS}" CACHE STRING "")
# set(CMAKE_EXE_LINKER_FLAGS_MINSIZEREL     "${AVR_EXE_LINKER_FLAGS}" CACHE STRING "")
# set(CMAKE_EXE_LINKER_FLAGS_RELEASE        "${AVR_EXE_LINKER_FLAGS}" CACHE STRING "")
# set(CMAKE_EXE_LINKER_FLAGS_RELWITHDEBINFO "${AVR_EXE_LINKER_FLAGS}" CACHE STRING "")

# Shared Lbrary Linker Flags
#=====================================================================
if(NOT DEFINED AVR_LIB_LINKER_FLAGS)
  set(AVR_LIB_LINKER_FLAGS "-fuse-linker-plugin -Wl,--gc-sections")
  # set(AVR_LIB_LINKER_FLAGS "-lc -lm")
  # set(AVR_LIB_LINKER_FLAGS "-Wl,--gc-sections,--print-gc-sections -lm -lc")
endif()

set(CMAKE_SHARED_LINKER_FLAGS                "${AVR_LIB_LINKER_FLAGS}" CACHE STRING "")
# set(CMAKE_SHARED_LINKER_FLAGS_DEBUG          "${AVR_LIB_LINKER_FLAGS}" CACHE STRING "")
# set(CMAKE_SHARED_LINKER_FLAGS_MINSIZEREL     "${AVR_LIB_LINKER_FLAGS}" CACHE STRING "")
# set(CMAKE_SHARED_LINKER_FLAGS_RELEASE        "${AVR_LIB_LINKER_FLAGS}" CACHE STRING "")
# set(CMAKE_SHARED_LINKER_FLAGS_RELWITHDEBINFO "${AVR_LIB_LINKER_FLAGS}" CACHE STRING "")

set(CMAKE_MODULE_LINKER_FLAGS                "${AVR_LIB_LINKER_FLAGS}" CACHE STRING "")
# set(CMAKE_MODULE_LINKER_FLAGS_DEBUG          "${AVR_LIB_LINKER_FLAGS}" CACHE STRING "")
# set(CMAKE_MODULE_LINKER_FLAGS_MINSIZEREL     "${AVR_LIB_LINKER_FLAGS}" CACHE STRING "")
# set(CMAKE_MODULE_LINKER_FLAGS_RELEASE        "${AVR_LIB_LINKER_FLAGS}" CACHE STRING "")
# set(CMAKE_MODULE_LINKER_FLAGS_RELWITHDEBINFO "${AVR_LIB_LINKER_FLAGS}" CACHE STRING "")

# Arduino Settings                                    
#=====================================================================
set(AVR_OBJCOPY_FLAGS_EEP -O ihex -j .eeprom --set-section-flags=.eeprom=alloc,load
    --no-change-warnings --change-section-lma .eeprom=0  CACHE STRING "")
set(AVR_OBJCOPY_FLAGS_HEX -O ihex -R .eeprom             CACHE STRING "")
set(AVR_FLASH_FLAGS -V                                   CACHE STRING "")

SET(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
SET(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
SET(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)
