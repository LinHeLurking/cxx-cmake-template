#
# Try to detect and load vcpkg toolchain.
# VCPKG configurations must be called before `project`.
#
if(DEFINED CMAKE_TOOLCHAIN_FILE)
  message(STATUS "Using toolchain file: ${CMAKE_TOOLCHAIN_FILE}")
elseif(DEFINED ENV{VCPKG_ROOT})
  # No toolchain provided, use vcpkg.
  set(CMAKE_TOOLCHAIN_FILE "$ENV{VCPKG_ROOT}/scripts/buildsystems/vcpkg.cmake")
  message(STATUS "No toolchain file provided. Load vcpkg directly from toolchain file: ${CMAKE_TOOLCHAIN_FILE}")
else()
  message(STATUS "No VCPKG found.")
endif()

project("PlayGround")
cmake_minimum_required(VERSION 3.20)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)
set(BUILD_TESTS ON CACHE BOOL "Whether to build tests")
set(VCPKG_MANIFEST_INSTALL OFF CACHE BOOL "Whether to install packages automatically")
find_package(Threads REQUIRED)


#
# Sources 
#
add_executable(main src/main.cc)


#
# Tests 
#
if(BUILD_TESTS)
  enable_testing()
      
  find_package(GTest CONFIG REQUIRED)

  macro(add_g_test name)
    add_executable(${name} ${ARGN})
    target_link_libraries(${name} INTERFACE Threads::Threads)
    target_link_libraries(${name} PRIVATE 
      GTest::gtest 
      GTest::gtest_main 
      GTest::gmock 
      GTest::gmock_main
    )
    add_test(${name} ${name})
  endmacro()

  add_g_test(sample test/test_sample.cc)
endif()
