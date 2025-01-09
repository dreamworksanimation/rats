# Copyright 2023 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

cmake_minimum_required (VERSION 3.23.1)

project(rats)

list(APPEND CMAKE_MESSAGE_CONTEXT ${PROJECT_NAME})
list(APPEND CMAKE_MODULE_PATH ${CMAKE_CURRENT_SOURCE_DIR}/cmake)

set(RATS_CANONICAL_DIR "" CACHE PATH "Directory to store/retrieve RaTS canonical images")
set(RATS_RENDER_THREADS "" CACHE STRING "Number of threads to use when rendering RaTS tests, leave blank to use all available cores")

if("$CACHE{RATS_CANONICAL_DIR}" STREQUAL "")
    set(example_path "/path/to/some/directory")
    cmake_path(NATIVE_PATH example_path NORMALIZE example_path_native)
    message(WARNING
            "  The RATS_CANONICAL_DIR must be set before the generation step - skipping the RaTS tests.\n"
            "  To generate the RATS CTest tests run the cmake configure step again with:\n"
            "            -DRATS_CANONICAL_DIR=${example_path_native}\n"
            "  or use ccmake or cmake_gui to set the RATS_CANONICAL_DIR cache variable and reconfigure/regenerate.")
else()
    message("RATS_CANONICAL_DIR: $CACHE{RATS_CANONICAL_DIR}")

    if("$CACHE{RATS_RENDER_THREADS}" STREQUAL "")
        message("RATS_RENDER_THREADS: <all cores>")
    else()
        message("RATS_RENDER_THREADS: $CACHE{RATS_RENDER_THREADS}")
    endif()

    find_program(IDIFF
        idiff
        DOC "path to the openimageio 'idiff' command-line tool"
        # FIXME: setting this HINT since without it our presets are causing it to find an
        # older version of oiiotool (2.3.20.0.x.0.1.0.1) which is found in the CMAKE_PREFIX_PATH,
        # and that version can't find the runtime libs it needs.
        NO_CMAKE_PATH
        HINTS /rel/rez/dwa/openimageio/2.4.8.0.x.1.0.0.0/cpp_std-17.0/boost-1.73.0.x.2/openexr-2.5.7.x.0/python-3.7/opencolorio-2.0.2.x.0/bin
        REQUIRED
    )
    message("IDIFF: ${IDIFF}")

    find_program(OIIOTOOL
        oiiotool
        DOC "path to the openimageio 'oiiotool' command-line tool"
        # FIXME: setting this HINT since without it our presets are causing it to find an
        # older version of oiiotool (2.3.20.0.x.0.1.0.1) which is found in the CMAKE_PREFIX_PATH,
        # and that version can't find the runtime libs it needs.
        NO_CMAKE_PATH
        HINTS /rel/rez/dwa/openimageio/2.4.8.0.x.1.0.0.0/cpp_std-17.0/boost-1.73.0.x.2/openexr-2.5.7.x.0/python-3.7/opencolorio-2.0.2.x.0/bin
        REQUIRED
    )
    message("OIIOTOOL: ${OIIOTOOL}")

    include(RatsTest)
    add_subdirectory(tests)
endif()
