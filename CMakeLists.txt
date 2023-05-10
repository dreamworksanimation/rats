# Copyright 2023 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

cmake_minimum_required (VERSION 3.23.1)

project(rats)

list(APPEND CMAKE_MESSAGE_CONTEXT ${PROJECT_NAME})
list(APPEND CMAKE_MODULE_PATH ${CMAKE_CURRENT_SOURCE_DIR}/cmake)

set(RATS_CANONICAL_PATH "" CACHE PATH "Path to canonical images")

# find idiff
find_package(OpenImageIO REQUIRED)
find_program(IDIFF
    idiff
    # FIXME: setting this HINT since without it our presets are causing it to find an
    # older version of oiiotool (2.3.20.0.x.0.1.0.1) which is found in the CMAKE_PREFIX_PATH,
    # and that version can't find the runtime libs it needs.
    NO_CMAKE_PATH
    HINTS /rel/rez/dwa/openimageio/2.4.8.0.x.1.0.0.0/cpp_std-17.0/boost-1.73.0.x.2/openexr-2.5.7.x.0/python-3.7/opencolorio-2.0.2.x.0/bin
    REQUIRED
)
message("IDIFF: ${IDIFF}")

include(RatsTest)

# TODO: Make sure canonical path is set and valid,
# or print message and don't add tests
add_subdirectory(tests)
