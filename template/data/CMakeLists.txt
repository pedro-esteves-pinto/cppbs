cmake_minimum_required(VERSION 3.5)
project(data_files)

include(${CMAKE_SOURCE_DIR}/cmake/safe_dep_glob.cmake)

# DEPENDENCIES
file (GLOB_RECURSE To_Copy RELATIVE ${CMAKE_CURRENT_SOURCE_DIR} files/*)
update_deps_file("${To_Copy}")
# END DEPENDENCIES

add_custom_command(OUTPUT ${CMAKE_BINARY_DIR}/bin/data
  COMMAND /bin/bash ${CMAKE_CURRENT_SOURCE_DIR}/copy_files.sh
  ARGS ${CMAKE_BINARY_DIR}/bin/data ${CMAKE_CURRENT_SOURCE_DIR} 
  COMMENT "Copying data files"
  DEPENDS ${CMAKE_CURRENT_SOURCE_DIR}/copy_files.sh ${To_Copy})

add_custom_target(data_files_dir ALL DEPENDS ${CMAKE_BINARY_DIR}/bin/data)

