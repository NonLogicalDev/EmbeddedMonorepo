function(collect_sources INC_VAR SRC_VAR DIR)
  set(GLB)
  math(EXPR ARGCM1 "${ARGC} - 1")

  foreach(I RANGE 3 ${ARGCM1})
    list(APPEND GLB "${DIR}/${ARGV${I}}")
  endforeach(I)

  set(${INC_VAR} ${${INC_VAR}} ${DIR} PARENT_SCOPE)

  if (GLB)
    file(GLOB_RECURSE INC_SRCS ${GLB})
  endif ()

  set(${SRC_VAR} ${${SRC_VAR}} ${INC_SRCS} PARENT_SCOPE)
endfunction()
