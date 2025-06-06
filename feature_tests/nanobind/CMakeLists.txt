# Set the minimum CMake version and policies for highest tested version
cmake_minimum_required(VERSION 3.15...3.27)

# Set up the project and ensure there is a working C++ compiler
project(my_ext LANGUAGES CXX)

# Warn if the user invokes CMake directly
if (NOT SKBUILD)
  message(WARNING "\
  This CMake file is meant to be executed using 'scikit-build-core'.
  Running it directly will almost certainly not produce the desired
  result. If you are a user trying to install this package, use the
  command below, which will install all necessary build dependencies,
  compile the package in an isolated environment, and then install it.
  =====================================================================
   $ pip install .
  =====================================================================
  If you are a software developer, and this is your own package, then
  it is usually much more efficient to install the build dependencies
  in your environment once and use the following command that avoids
  a costly creation of a new virtual environment at every compilation:
  =====================================================================
   $ pip install nanobind scikit-build-core[pyproject]
   $ pip install --no-build-isolation -ve .
  =====================================================================
  You may optionally add -Ceditable.rebuild=true to auto-rebuild when
  the package is imported. Otherwise, you need to rerun the above
  after editing C++ files.")
endif()

# Try to import all Python components potentially needed by nanobind
find_package(Python 3.8
  REQUIRED COMPONENTS Interpreter Development.Module
  OPTIONAL_COMPONENTS Development.SABIModule)

set(DIPLOMAT_ROOT ${CMAKE_CURRENT_SOURCE_DIR}/../..)
# Import nanobind through CMake's find_package mechanism
set(nanobind_ROOT "${DIPLOMAT_ROOT}/vendor/nanobind")
find_package(nanobind CONFIG REQUIRED HINTS "${DIPLOMAT_ROOT}/vendor/nanobind")

# Add our rust library as a custom target, it contains the actual definitions of the things we're binding
set(FEATURE_TEST_LIB_FILE ${DIPLOMAT_ROOT}/target/debug/${CMAKE_STATIC_LIBRARY_PREFIX}diplomat_feature_tests${CMAKE_STATIC_LIBRARY_SUFFIX})
add_custom_command(OUTPUT ${FEATURE_TEST_LIB_FILE}
    COMMAND cargo build
)
add_custom_target(diplomat_feature_tests_target DEPENDS ${FEATURE_TEST_LIB_FILE})
add_library(diplomat_feature_tests STATIC IMPORTED GLOBAL)
add_dependencies(diplomat_feature_tests diplomat_feature_tests_target)
set_target_properties(diplomat_feature_tests PROPERTIES IMPORTED_LOCATION ${FEATURE_TEST_LIB_FILE})
if(WIN32)
  target_link_libraries(diplomat_feature_tests INTERFACE kernel32.lib advapi32.lib ntdll.lib userenv.lib ws2_32.lib dbghelp.lib)
endif()

# We are now ready to compile the actual extension module
nanobind_add_module(
  # Name of the extension
  somelib

  # Target the stable ABI for Python 3.12+, which reduces
  # the number of binary wheels that must be built. This
  # does nothing on older Python versions
  STABLE_ABI

  NB_STATIC

  # Source code goes here
  src/somelib_ext.cpp
)
target_include_directories(somelib PUBLIC "src/include" "${nanobind_ROOT}/ext/robin_map/include")
target_compile_features(somelib PUBLIC cxx_std_20)
target_link_libraries(somelib PUBLIC diplomat_feature_tests ${Python3_SABI_LIBRARY})

# Install directive for scikit-build-core
install(TARGETS somelib LIBRARY DESTINATION somelib)