# Copyright 2023-2025 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

# ==================================================================================
# This is an example of a simple custom diff script. By including a script like this
# named 'diff.cmake' in the same directory as your RATS test it will be used as the
# diff tool for comparing that test's canonicals, rather than the default 'idiff'.
#
# This particular custom diff script isn't very interesting since it simply wraps idiff.

# The following variables are defined by the RATS CTest framework and are provided
# for use in this script:

#   CANONICAL                   : filename of the canonical to be compared with the test image, needs to
#                                   be expanded at runtime to query $RATS_CANONICAL_DIR (see below)
#   DIFF_ARGS                   : list of arguments to pass to the diff tool (from your test's IDIFF_ARGS_* )
#   DIFF_IMAGE                  : filename for writing a diff output image
#   EXEC_MODE                   : scalar|vector|xpu
#   IDIFFTOOL                   : location of idiff executable as found by CMake
#   OIIOTOOL                    : location of oiiotool executable as found by CMake
#   RESULT                      : filename of the test image to be compared with the canonical
#
# To pass this diff test, simply let this script exit.
# To fail this diff test, output a message with the FATAL_ERROR mode.

# message("CANONICAL      : ${CANONICAL}")
# message("DIFF_ARGS      : ${DIFF_ARGS}")
# message("DIFF_IMAGE     : ${DIFF_IMAGE}")
# message("EXEC_MODE      : ${EXEC_MODE}")
# message("IDIFFTOOL      : ${IDIFFTOOL}")
# message("OIIOTOOL       : ${OIIOTOOL}")
# message("RESULT         : ${RESULT}")

if(NOT DEFINED ENV{RATS_CANONICAL_DIR})
    message(FATAL_ERROR "RATS_CANONICAL_DIR is undefined")
endif()

file(TO_NATIVE_PATH "$ENV{RATS_CANONICAL_DIR}/${CANONICAL}" full_canonical_path)

execute_process(
    COMMAND ${IDIFFTOOL} ${DIFF_ARGS} -o ${DIFF_IMAGE} ${full_canonical_path} ${RESULT}
    COMMAND_ECHO STDOUT
    RESULT_VARIABLE exit_code
)

# idiff returns 1 on warning and 2 on error
if(exit_code EQUAL 2)
    message(FATAL_ERROR "diff failed!")
endif()

