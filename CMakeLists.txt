cmake_minimum_required(VERSION 3.27) # TODO: investigate if this is the minimum

# Set the project name
project(
  CPPTemplate
  VERSION 0.0.1
  LANGUAGES C CXX)

message(STATUS "System Name: ${CMAKE_SYSTEM_NAME}")
message(STATUS "C Compiler: ${CMAKE_C_COMPILER}")
message(STATUS "CXX Compiler: ${CMAKE_CXX_COMPILER}")
message(STATUS "Make program: ${CMAKE_MAKE_PROGRAM}")

include(cmake/extern/CPM.cmake/cmake/CPM.cmake)
cpmaddpackage("gh:TheLartians/PackageProject.cmake@1.13.0")
cpmaddpackage("gh:TheLartians/Format.cmake@1.8.3")

# Specify the C++ standard
set(CMAKE_CXX_STANDARD 23)
set(CMAKE_CXX_STANDARD_REQUIRED True)

file(GLOB_RECURSE c_headers CONFIGURE_DEPENDS
     "${CMAKE_CURRENT_SOURCE_DIR}/include/*.h")
file(GLOB_RECURSE c_sources CONFIGURE_DEPENDS
     "${CMAKE_CURRENT_SOURCE_DIR}/source/*.c")
file(GLOB_RECURSE cxx_headers CONFIGURE_DEPENDS
     "${CMAKE_CURRENT_SOURCE_DIR}/include/*.hpp")
file(GLOB_RECURSE cpp_sources CONFIGURE_DEPENDS
     "${CMAKE_CURRENT_SOURCE_DIR}/source/*.cpp")
file(GLOB_RECURSE cxx_sources CONFIGURE_DEPENDS
     "${CMAKE_CURRENT_SOURCE_DIR}/source/*.cxx")

message(STATUS "c_headers: ${c_headers}")
message(STATUS "c_sources: ${c_sources}")
message(STATUS "cxx_headers: ${cxx_headers}")
message(STATUS "cxx_headers: ${cxx_headers}")
message(STATUS "cxx_sources: ${cxx_sources}")
message(STATUS "cpp_sources: ${cpp_sources}")

# Both built into single library for now...
add_library(${PROJECT_NAME} STATIC ${c_headers} ${c_sources} ${cxx_headers}
                                   ${cpp_sources} ${cxx_sources})

# Can I set both standards?
set_property(TARGET ${PROJECT_NAME} PROPERTY C_STANDARD 11)
set_property(TARGET ${PROJECT_NAME} PROPERTY CXX_STANDARD 20)

target_compile_options(${PROJECT_NAME}
                       PUBLIC "$<$<COMPILE_LANG_AND_ID:CXX,MSVC>:/permissive->")

# target_link_libraries(${PROJECT_NAME}) target_link_libraries(${PROJECT_NAME}
# PRIVATE cairo Eigen3::Eigen matplot)

target_include_directories(
  ${PROJECT_NAME}
  PUBLIC $<BUILD_INTERFACE:${PROJECT_SOURCE_DIR}/include>
         $<INSTALL_INTERFACE:include/${PROJECT_NAME}-${PROJECT_VERSION}>)

string(TOLOWER ${PROJECT_NAME}/version.h VERSION_HEADER_LOCATION)

packageproject(
  NAME
  ${PROJECT_NAME}
  VERSION
  ${PROJECT_VERSION}
  NAMESPACE
  ${PROJECT_NAME}
  BINARY_DIR
  ${PROJECT_BINARY_DIR}
  INCLUDE_DIR
  ${PROJECT_SOURCE_DIR}/include
  INCLUDE_DESTINATION
  include/${PROJECT_NAME}-${PROJECT_VERSION}
  VERSION_HEADER
  "${VERSION_HEADER_LOCATION}"
  COMPATIBILITY
  SameMajorVersion
  DEPENDENCIES
  "")

# Add the executable
add_executable(cpptemplate main.cpp)
target_link_libraries(cpptemplate PRIVATE ${PROJECT_NAME})


# add_custom_target(CreateSymlink ALL
#     COMMAND ${CMAKE_COMMAND} -E create_symlink
#         "${CMAKE_CURRENT_BINARY_DIR}/compile_commands.json"
#         "${CMAKE_SOURCE_DIR}/compile_commands.json"
#     DEPENDS ${CMAKE_CURRENT_BINARY_DIR}/compile_commands.json
#     COMMENT "Creating symlink to compile_commands.json"
# )

