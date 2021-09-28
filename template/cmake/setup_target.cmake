include(${CMAKE_SOURCE_DIR}/cmake/setup_protobuf_compilation.cmake)
include(${CMAKE_SOURCE_DIR}/cmake/safe_dep_glob.cmake)

function(setup_executable FOR_TARGET TARGET_DEPENDENCIES)
   # get normal sources
   file(GLOB_RECURSE SRCS RELATIVE ${CMAKE_CURRENT_SOURCE_DIR} *.cpp)
   if (${SRCS}) 
     update_deps_file(${SRCS})
   endif()

   # add executable target
   add_executable(${FOR_TARGET} ${SRCS})
   # clang-tidy is slow, we save it for the release builds
   if (CMAKE_BUILD_TYPE STREQUAL "Release")
     set_target_properties(${FOR_TARGET} PROPERTIES CXX_CLANG_TIDY clang-tidy)
   endif()

   # get protos
   setup_protobuf_compilation(${FOR_TARGET} HAS_PROTOS)
   if (HAS_PROTOS)
     target_link_libraries(${FOR_TARGET} ${FOR_TARGET}_proto)
   endif()

   # proto headers
   target_include_directories(${FOR_TARGET} BEFORE PUBLIC
     ${CMAKE_BINARY_DIR}/gen_proto/app_${FOR_TARGET})
   target_include_directories(${FOR_TARGET} BEFORE PUBLIC
     ${CMAKE_BINARY_DIR}/gen_proto)

   # Accessing our own headers
   target_include_directories(${FOR_TARGET} BEFORE PUBLIC
     ${CMAKE_CURRENT_SOURCE_DIR})

   # allow executable to use dependencies
   foreach(D ${TARGET_DEPENDENCIES})
     target_include_directories(${FOR_TARGET} BEFORE PUBLIC
       ${CMAKE_SOURCE_DIR}/src/lib_${D})
     target_include_directories(${FOR_TARGET} BEFORE PUBLIC
       ${CMAKE_BINARY_DIR}/gen_proto/lib_${D})
     target_link_libraries(${FOR_TARGET} ${D})
   endforeach()
   target_link_libraries(${FOR_TARGET} ${CONAN_LIBS})
endfunction()

function(setup_library FOR_TARGET TARGET_DEPENDENCIES)
   # get normal sources
   file(GLOB_RECURSE SRCS RELATIVE ${CMAKE_CURRENT_SOURCE_DIR} *.cpp)
   if (${SRCS}) 
     update_deps_file(${SRCS})
   endif()

   # add library target
   add_library(${FOR_TARGET} ${SRCS})
   # clang-tidy is slow, we save it for the release builds
   if (CMAKE_BUILD_TYPE STREQUAL "Release")
     set_target_properties(${FOR_TARGET} PROPERTIES CXX_CLANG_TIDY clang-tidy)
   endif()

   # get protos
   setup_protobuf_compilation(${FOR_TARGET} HAS_PROTOS )
   if (HAS_PROTOS)
     target_link_libraries(${FOR_TARGET} ${FOR_TARGET}_proto)
   endif()

   # Accessing our own proto's headers
   target_include_directories(${FOR_TARGET} BEFORE PUBLIC
     ${CMAKE_BINARY_DIR}/gen_proto/lib_${FOR_TARGET})
   target_include_directories(${FOR_TARGET} BEFORE PUBLIC
     ${CMAKE_BINARY_DIR}/gen_proto)

   # Accessing our own headers
   target_include_directories(${FOR_TARGET} BEFORE PUBLIC
     ${CMAKE_CURRENT_SOURCE_DIR})

   # Accessing our own headers
   target_include_directories(${FOR_TARGET} BEFORE PUBLIC
     ${CMAKE_CURRENT_SOURCE_DIR})

   # allow library to use dependencies, both normal and protos
   foreach(D ${TARGET_DEPENDENCIES})
     target_include_directories(${FOR_TARGET} BEFORE PUBLIC
       ${CMAKE_SOURCE_DIR}/src/lib_${D})
     target_include_directories(${FOR_TARGET} BEFORE PUBLIC
       ${CMAKE_BINARY_DIR}/gen_proto/lib_${D})
     target_link_libraries(${FOR_TARGET} ${D})
   endforeach()
   target_link_libraries(${FOR_TARGET} ${CONAN_LIBS})
endfunction()
