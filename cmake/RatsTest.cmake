# Copyright 2023 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

function(rats_oiio_diff test_name)
    set(options FOO)
    set(oneValueArgs WORKING_DIRECTORY)
    set(multiValueArgs COMMAND)
    cmake_parse_arguments(ARG "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})
endfunction()

