set(ARDUINO_SRCS)
set(ARDUINO_INCLUDES)
set(ARDUINO_LIBS)

function(INIT_ARDUINO_CORE)
  set(ARDUINO_ROOT "${PROJECT_PATH}/Toolchain/Core/arduino/avr")

  list(APPEND ADD_PROJECT_DEFINES "ARDUINO=10612")
  list(APPEND ADD_PROJECT_DEFINES "ARDUINO_AVR_UNO")
  list(APPEND ADD_PROJECT_DEFINES "ARDUINO_ARCH_AVR")

  # Set up Arduino settings
  set(ARDUINO_CORES_PATH ${ARDUINO_ROOT}/cores/arduino CACHE STRING "")
  set(ARDUINO_VARIANTS_PATH ${ARDUINO_ROOT}/variants/eightanaloginputs CACHE STRING "")
  set(ARDUINO_LIBRARIES_PATH ${ARDUINO_ROOT}/libraries CACHE STRING "")

  collect_sources(ARDUINO_INCLUDES ARDUINO_SRCS "${ARDUINO_CORES_PATH}")
  collect_sources(ARDUINO_INCLUDES ARDUINO_SRCS "${ARDUINO_VARIANTS_PATH}")

  file(GLOB ARDUINO_LIB_DIRS ${ARDUINO_LIBRARIES_PATH}/*)
  foreach(libdir IN ITEMS ${ARDUINO_LIB_DIRS})
    get_filename_component(libname ${libdir} NAME)
    if(IS_DIRECTORY ${libdir})
      message(STATUS "Adding Arduino Library: (${libname}) ${libdir}")
      collect_sources(${libname}_INCLUDES ${libname}_SRCS "${libdir}")

      if (${libname}_INCLUDES)
        list(APPEND ARDUINO_INCLUDES ${${libname}_INCLUDES})
      endif()

      if (${libname}_SRCS)
        message(">> ${${libname}_INCLUDES}")

        set(${libname}_SRCS ${${libname}_SRCS})
        set(${libname}_INCLUDES ${${libname}_INCLUDES} ${ARDUINO_INCLUDES})

        make_avr_library(${libname})
        list(APPEND ARDUINO_LIBS ${libname})
      endif()
    endif()
  endforeach()

  foreach (inc ${ARDUINO_INCLUDES})
    message(">> (I): ${inc}")
  endforeach()

  set(ARDUINO_SRCS ${ARDUINO_SRCS} PARENT_SCOPE)
  set(ARDUINO_INCLUDES ${ARDUINO_INCLUDES} PARENT_SCOPE)
  set(ARDUINO_LIBS ${ARDUINO_LIBS} PARENT_SCOPE)

  set(PROJECT_DEFINES ${PROJECT_DEFINES} ${ADD_PROJECT_DEFINES} PARENT_SCOPE)
endfunction()
