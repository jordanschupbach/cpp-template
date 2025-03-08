cmake_minimum_required(VERSION 3.14...3.22) # TODO audit these versions

project(cpptemplateTests LANGUAGES CXX)
option(ENABLE_TEST_COVERAGE "Enable test coverage" ON)
option(TEST_INSTALLED_VERSION "Test the version found by find_package" OFF)
# include(../cmake/tools.cmake)
include(../cmake/extern/CPM.cmake/cmake/CPM.cmake)
cpmaddpackage("gh:doctest/doctest@2.4.9")

if(TEST_INSTALLED_VERSION)
  find_package(CPPTemplate REQUIRED)
else()
  cpmaddpackage(NAME CPPTemplate SOURCE_DIR ${CMAKE_CURRENT_LIST_DIR}/..)
endif()

file(GLOB_RECURSE sources CONFIGURE_DEPENDS ${CMAKE_CURRENT_SOURCE_DIR}/source/*.cpp)

add_executable(${PROJECT_NAME} ${sources})
target_link_libraries(${PROJECT_NAME} doctest::doctest CPPTemplate::CPPTemplate)

set_target_properties(${PROJECT_NAME} PROPERTIES CXX_STANDARD 17)

if(NOT TEST_INSTALLED_VERSION)
  if(CMAKE_CXX_COMPILER_ID MATCHES "Clang" OR CMAKE_CXX_COMPILER_ID MATCHES
                                              "GNU")
                                            target_compile_options(CPPTemplate PUBLIC -Wall -Wpedantic -Wextra -Werror)
  elseif(MSVC)
    # target_compile_options(CPPTemplate PUBLIC /W4 /WX)
    target_compile_definitions(${PROJECT_NAME}
                               PUBLIC DOCTEST_CONFIG_USE_STD_HEADERS)
  endif()
endif()

enable_testing()

include(${doctest_SOURCE_DIR}/scripts/cmake/doctest.cmake)
doctest_discover_tests(${PROJECT_NAME})

