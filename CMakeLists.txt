#
# Set up multi-config generator
#
if(NOT SET_UP_CONFIGURATIONS_DONE)
  set(SET_UP_CONFIGURATIONS_DONE TRUE)

  # No reason to set CMAKE_CONFIGURATION_TYPES if it's not a multiconfig generator
  # Also no reason mess with CMAKE_BUILD_TYPE if it's a multiconfig generator.
  get_property(isMultiConfig GLOBAL PROPERTY GENERATOR_IS_MULTI_CONFIG)
  if(isMultiConfig)
    message(STATUS "Generating multi-config for ${CMAKE_GENERATOR}")
    set(CMAKE_CONFIGURATION_TYPES "Debug;Release;RelWithDebInfo;MinSizeRel" CACHE STRING "" FORCE) 
  else()
    if(NOT CMAKE_BUILD_TYPE)
      message("Defaulting to debug build.")
      set(CMAKE_BUILD_TYPE Debug CACHE STRING "" FORCE)
    endif()
    set_property(CACHE CMAKE_BUILD_TYPE PROPERTY HELPSTRING "Choose the type of build")
    # set the valid options for cmake-gui drop-down list
    set_property(CACHE CMAKE_BUILD_TYPE PROPERTY STRINGS "Debug;Release;RelWithDebInfo;MinSizeRel")
  endif()
  # If you need custom compile flags, add "Custom" into "CMAKE_CONFIGURATION_TYPES".
  # Then set up these flags.
  # set(CMAKE_C_FLAGS_CUSTOM "...")
  # set(CMAKE_CXX_FLAGS_CUSTOM "...")
  # set(CMAKE_EXE_LINKER_FLAGS_CUSTOM "...")
endif()


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
