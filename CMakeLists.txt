# Copyright 2023 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

cmake_minimum_required (VERSION 3.23.1)

project(rats)

list(APPEND CMAKE_MESSAGE_CONTEXT ${PROJECT_NAME})
list(APPEND CMAKE_MODULE_PATH ${CMAKE_CURRENT_SOURCE_DIR}/cmake)

find_program(IDIFF
    idiff
    DOC "path to the openimageio 'idiff' command-line tool"
    REQUIRED
)

find_program(OIIOTOOL
    oiiotool
    DOC "path to the openimageio 'oiiotool' command-line tool"
    REQUIRED
)

include(RatsTest)
add_subdirectory(tests)
