# Copyright 2023 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

# =====================================================================================
# This script is run during execution of the rats tests via
#     ${CMAKE_COMMAND} -P <thisscript>.cmake -DEXAMPLE_DEF1=... -DEXAMPLE_DEF2=...
#
# It is responsible for executing a render and copying the outputs to the canonicals dir
# -------------------------------------------------------------------------------------
#
# Required definitions:
#   CANONICALS_DIR  : directory to store the canonicals. It will be created if necessary.
#   CANONICALS      : list of output images to be stored as canonicals, eg.
#                       scene.exr;aovs.exr;more_aovs.exr
#   RENDER_CMD      : fully qualified render commnd line as a list, eg:
#                       /path/to/moonray;-in;scene.rdla;-exec_mode;scalar
# -------------------------------------------------------------------------------------
# Validate script inputs, these are required to be defined by the calling code
foreach(required_def CANONICALS_DIR CANONICALS RENDER_CMD)
    if(NOT DEFINED ${required_def})
        message(FATAL_ERROR "${required_def} is undefined")
    endif()
endforeach()
# =====================================================================================



macro(exec_and_check)
    set(args ${ARGV})
    list(POP_FRONT args cmd)

    execute_process(
        COMMAND ${cmd} ${args}
        RESULT_VARIABLE result
        COMMAND_ECHO STDOUT
        ECHO_OUTPUT_VARIABLE
        ECHO_ERROR_VARIABLE
    )
    if(result)
        message(FATAL_ERROR "${result}")
    endif()
endmacro()


# run moonray
exec_and_check(${RENDER_CMD})

if(CANONICALS)
    # make the directory for the canonicals
    set(mkdir_cmd ${CMAKE_COMMAND} -E make_directory ${CANONICALS_DIR})
    exec_and_check(${mkdir_cmd})

    # copy the outputs to the canonicals dir
    set(copy_cmd ${CMAKE_COMMAND} -E copy ${CANONICALS} ${CANONICALS_DIR})
    exec_and_check(${copy_cmd})
endif()

