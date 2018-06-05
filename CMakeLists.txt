cmake_minimum_required(VERSION 3.11.0)

include(${CMAKE_CURRENT_LIST_DIR}/build/cmake/CMakeModules/HunterGate.cmake)

HunterGate(
    URL "https://github.com/Walter1337/hunter/archive/v0.22.3.tar.gz"
    SHA1 "70a82073d9fb36d5ab95ecd92abe8c426db431cb"
)

# This declares the project (solution in terms of MSVC) we're working on,
# and incidentally, informs CMake that the directory we're in is the top-level
# source directory. This will set PROJECT_SOURCE_DIR properly.
project(wxWidgets)

# Note that while I have successfully put this file in a subdirectory
# (namely build/cmake/), this meant that PROJECT_SOURCE_DIR would point
# to the build system, and not the source tree. This could be very confusing
# especially if wxWidgets is to be embedded in a larger tree.
# If this needs to be done again (because we see there is no issue after all)
# one needs to change the WX_SOURCE_DIR definition below.
# This is also the reason why neither PROJECT_SOURCE_DIR nor CMAKE_SOURCE_DIR
# are ever actually used in the CMakeLists.txt files.
set(WX_SOURCE_DIR ${PROJECT_SOURCE_DIR})
# Set a helper var to designate the directory where the CMake files are (note
# that this is *not* the CMAKE_BINARY_DIR). This variable should be used
# for all include() calls inside those scripts (as include()ing a file does
# not change the CWD). [Alternatively, CMAKE_CURRENT_LIST_DIR can also be
# used to locate files for inclusion].
set(WX_CMAKE_DIR ${PROJECT_SOURCE_DIR}/build/cmake)

# parse the version number from gdal_version.h and include in wxMAJOR_VERSION and wxMINOR_VERSION
file(READ ${PROJECT_SOURCE_DIR}/include/wx/version.h WX_VERSION_H_CONTENTS)
string(REGEX MATCH "wxMAJOR_VERSION[ \t]+([0-9]+)"
  wxMAJOR_VERSION ${WX_VERSION_H_CONTENTS})
string (REGEX MATCH "([0-9]+)"
  wxMAJOR_VERSION ${wxMAJOR_VERSION})
string(REGEX MATCH "wxMINOR_VERSION[ \t]+([0-9]+)"
  wxMINOR_VERSION ${WX_VERSION_H_CONTENTS})
string (REGEX MATCH "([0-9]+)"
  wxMINOR_VERSION ${wxMINOR_VERSION})
string(REGEX MATCH "wxRELEASE_NUMBER[ \t]+([0-9]+)"
  wxRELEASE_NUMBER ${WX_VERSION_H_CONTENTS})
string (REGEX MATCH "([0-9]+)"
  wxRELEASE_NUMBER ${wxRELEASE_NUMBER})

# Setup package meta-data
set(WX_VERSION ${wxMAJOR_VERSION}.${wxMINOR_VERSION}.${wxRELEASE_NUMBER})
message(STATUS "wxwidgets version=[${WX_VERSION}]")

set(CMAKE_COLOR_MAKEFILE ON)
# Now we can include the files doing the real work.
include("${WX_CMAKE_DIR}/wxwidgets.cmake")
