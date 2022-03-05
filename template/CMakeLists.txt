cmake_minimum_required(VERSION 3.15)
project(myproject)

set (BASE_CXX_FLAGS "${CMAKE_CXX_FLAGS_DEBUG} \
  -Wall -Wextra -Wpedantic -Werror -Wmisleading-indentation \
  -g --std=c++2a -fdiagnostics-color")

set (CMAKE_CXX_FLAGS_DEBUG "${BASE_CXX_FLAGS} \
  -fsanitize=undefined,address,leak")
 
set (CMAKE_CXX_FLAGS_RELEASE "${BASE_CXX_FLAGS} \
  -DNDEBUG -O3")

# use ccache when possible
set(CMAKE_CXX_COMPILER_LAUNCHER ccache)

# Setting up Conan 
include(${CMAKE_BINARY_DIR}/conanbuildinfo.cmake)
set(CONAN_SYSTEM_INCLUDES ON)
set(CONAN_CMAKE_SILENT_OUTPUT ON)
conan_basic_setup()
# End setting up conan

add_subdirectory(data)

file( GLOB SDIRS src/*)
foreach( file ${SDIRS})
  get_filename_component(PRJ ${file} NAME)
  add_subdirectory (src/${PRJ}) 
endforeach( file ${SDIRS} )


