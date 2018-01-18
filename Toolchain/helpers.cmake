function(collect_sources INC_VAR SRC_VAR DIR)
  file(GLOB_RECURSE sources ${DIR}/*.cpp ${DIR}/*.S ${DIR}/*.c)
  file(GLOB_RECURSE headers ${DIR}/*.h ${DIR}/*.hpp)

  string(REGEX REPLACE "examples?/.*" "" sources "${sources}")
  string(REGEX REPLACE "examples?/.*" "" headers "${headers}")

  set(INCLUDE_PATHS)
  foreach (header ${headers}) 
    get_filename_component(dir ${header} PATH)
    list(APPEND INCLUDE_PATHS ${dir})
  endforeach()
  list(REMOVE_DUPLICATES INCLUDE_PATHS)
  
  set(${INC_VAR} ${${INC_VAR}} ${INCLUDE_PATHS} PARENT_SCOPE)
  set(${SRC_VAR} ${${SRC_VAR}} ${sources} PARENT_SCOPE)
endfunction()
