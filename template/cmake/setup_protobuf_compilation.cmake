include(${CMAKE_SOURCE_DIR}/cmake/safe_dep_glob.cmake)

find_package (Protobuf REQUIRED)

function(Protobuf_Generate_Cpp SRCS HDRS)

  # initialize outputs to empty
  set(${SRCS})
  set(${HDRS})

  set(PROTO_OUT ${CMAKE_BINARY_DIR}/gen_proto)
  get_filename_component(PARENT_DIR ${CMAKE_CURRENT_SOURCE_DIR} NAME_WE)
  set(THIS_PROTO_OUT ${PROTO_OUT}/${PARENT_DIR})

  # for each of the passed protos
  foreach(FIL ${ARGN})
    # get the absolute file name
    get_filename_component(ABS_FIL ${FIL} ABSOLUTE)
    # get the filename without its extention 
    get_filename_component(FIL_WE ${FIL} NAME_WE)
    # get just the directory component
    get_filename_component(FIL_DIR ${FIL} DIRECTORY)
    # add the directory to the extensionles file name
    if(FIL_DIR)
     set(FIL_WE "${FIL_DIR}/${FIL_WE}")
    endif()

    # form the file names of the pair of generated files: .pb.cc and pb.h
    # .pb.cc's are what we will need to compile
    list(APPEND ${SRCS} "${THIS_PROTO_OUT}/${FIL_WE}.pb.cc")
    list(APPEND ${HDRS} "${THIS_PROTO_OUT}/${FIL_WE}.pb.h")

    # add a custom command to generate the proto to the build
    add_custom_command(
      OUTPUT "${THIS_PROTO_OUT}/${FIL_WE}.pb.cc"
             "${THIS_PROTO_OUT}/${FIL_WE}.pb.h"
      COMMAND  ${Protobuf_PROTOC_EXECUTABLE}
      ARGS
      --cpp_out=${PROTO_OUT}
      -I ${PROTOBUF_INCLUDE_DIRS}
      -I ${CMAKE_SOURCE_DIR}/src
      ${ABS_FIL}
      DEPENDS ${ABS_FIL} 
      COMMENT "Running C++ protocol buffer compiler on ${FIL}"
      VERBATIM )
  endforeach()

  # note to CMake that these files are generated
  set_source_files_properties(${${SRCS}} ${${HDRS}} PROPERTIES GENERATED TRUE)

  # remove some warnings from protobuf generated files
  set_source_files_properties(${${SRCS}} PROPERTIES COMPILE_FLAGS
    "-Wno-unused-parameter -Wno-effc++ -Wno-pedantic -Wno-sign-compare -Wno-uninitialized")

  # return srcs and headers that will be generated
  set(${SRCS} ${${SRCS}} PARENT_SCOPE)
  set(${HDRS} ${${HDRS}} PARENT_SCOPE)
endfunction()

function(setup_protobuf_compilation FOR_TARGET HAS_PROTOS)
  file(GLOB_RECURSE PROTO_FILES RELATIVE ${CMAKE_CURRENT_SOURCE_DIR} *.proto)
  set (PROTO_LIB ${FOR_TARGET}_proto)
  if(PROTO_FILES) 
    protobuf_generate_cpp(PROTO_SRCS PROTO_HDRS ${PROTO_FILES})
    add_library(${PROTO_LIB} OBJECT ${PROTO_SRCS})
    target_include_directories(${PROTO_LIB} BEFORE PUBLIC ${CMAKE_BINARY_DIR}/gen_proto)
    set_target_properties(${PROTO_LIB} PROPERTIES CXX_CLANG_TIDY "")
    update_deps_file(${PROTO_FILES})
    set(${HAS_PROTOS} "1" PARENT_SCOPE)
  else()
    set(${HAS_PROTOS} "" PARENT_SCOPE)
  endif()
endfunction()
