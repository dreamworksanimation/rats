# Copyright 2023 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

# -------------------------------------------------------------------------------------
# This script expects to be run with the following variables defined:
#   MOONRAY_CMD     : fully qualified moonray commnd line as a list, eg:
#                       /path/to/moonray;-in;scene.rdla;-exec_mode;scalar
#   CANONCAL_PATH   : directory to store the caonicals. It will be created if necessary.
#   OUTPUTS         : list of output images to be stored as canonicals, eg.
#                       scene.exr;aovs.exr;more_aovs.exr
# -------------------------------------------------------------------------------------

macro(exec_and_check)
    set(args ${ARGV})
    list(POP_FRONT args cmd)

    execute_process(
        COMMAND ${cmd} ${args}
        RESULT_VARIABLE CMD_RESULT
        COMMAND_ECHO STDOUT
        ECHO_OUTPUT_VARIABLE
        ECHO_ERROR_VARIABLE
    )
    if(CMD_RESULT)
        message(FATAL_ERROR "${CMD_RESULT}")
    endif()
endmacro()


# run moonray
exec_and_check(${MOONRAY_CMD})

# make the directory for the canonicals
set(mkdir_cmd ${CMAKE_COMMAND} -E make_directory ${CANONICAL_PATH})
exec_and_check(${mkdir_cmd})

# copy the outputs to the canonicals dir
set(copy_cmd ${CMAKE_COMMAND} -E copy ${OUTPUTS} ${CANONICAL_PATH})
exec_and_check(${copy_cmd})


