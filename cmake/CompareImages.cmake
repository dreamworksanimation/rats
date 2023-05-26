# Copyright 2023 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

# =====================================================================================
# This script is ran during execution of the rats tests via
#     ${CMAKE_COMMAND} -P <thisscript>.cmake -DEXAMPLE_DEF1=... -DEXAMPLE_DEF2=...
#
# It is responsible for diff'ing a pair of [canonical,result] images
# -------------------------------------------------------------------------------------
#
# Required definitions:
#   EXEC_MODE           : used to determine which defaults to use (scalar|vector|xpu)
#   CANONCAL            : full path to the canonical image, .eg /some/path/to/canonicals/beauty.exr
#   RESULT              : name of the result image, eg. beauty.exr
#   IDIFF               : full path to the openimageio 'idiff' cmd
#
# Optional definitions:
#   IDIFF_ARGS          : list of user-specified arguments to the idiff tool,
#                           which will override the execution mode defaults
# -------------------------------------------------------------------------------------
# Validate script inputs, these are required to be defined by the calling code
foreach(required_def EXEC_MODE CANONICAL RESULT IDIFF)
    if(NOT DEFINED ${required_def})
        message(FATAL_ERROR "${required_def} is undefined")
    endif()
endforeach()
# =====================================================================================



# Build list of arguments for the idiff cmd.  Each execution mode has a
# set of defaults, and any user-specifed arguments are parsed here and
# override the defaults.
function(override_idiff_args out_var)
    set(options -p -q -a -abs -v)
    set(oneValueArgs EXEC_MODE -fail -failrelative -failpercent -hardfail -allowfailures -warn -warnrelative -warnpercent -hardwarn -scale)
    set(multiValueArgs "") # currently unused

    # parse and validate function arguments
    cmake_parse_arguments(ARG "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})
    if(DEFINED ARG_KEYWORDS_MISSING_VALUES)
        message(FATAL_ERROR "Keywords missing values: ${ARG_KEYWORDS_MISSING_VALUES}")
    endif()
    if(DEFINED ARG_UNPARSED_ARGUMENTS)
        message(FATAL_ERROR "Unrecognized arguments: ${ARG_UNPARSED_ARGUMENTS}")
    endif()
    if(NOT DEFINED ARG_EXEC_MODE)
        message(FATAL_ERROR "You must specify EXEC_MODE.")
    endif()

    # DEFAULT IDIFF ARGUMENTS

    # Commented default arguments below are not set by this function
    # unless overridden by user but are left in place for future use.
    if(${ARG_EXEC_MODE} STREQUAL "scalar")
        set(default_fail            0.004)
        # set(default_failrelative    0)
        set(default_failpercent     0.01)
        set(default_hardfail        0.02)
        # set(default_allowfailures   0)
        set(default_warn            0.004)
        # set(default_warnrelative    0)
        set(default_warnpercent     0.01)
        # set(default_hardwarn        inf)
        # set(default_scale           1)
        # set(default_p               FALSE)
        # set(default_q               FALSE)
        set(default_a               TRUE)   # always set
        set(default_abs             TRUE)   # always set
        set(default_v               TRUE)   # always set
    elseif(${ARG_EXEC_MODE} STREQUAL "vector" OR ${ARG_EXEC_MODE} STREQUAL "xpu")
        set(default_fail            0.007)
        # set(default_failrelative    0)
        set(default_failpercent     0.02)
        set(default_hardfail        0.02)
        # set(default_allowfailures   0)
        set(default_warn            0.007)
        # set(default_warnrelative    0)
        set(default_warnpercent     0.02)
        # set(default_hardwarn        inf)
        # set(default_scale           1)
        # set(default_p               FALSE)
        # set(default_q               FALSE)
        set(default_a               TRUE)   # always set
        set(default_abs             TRUE)   # always set
        set(default_v               TRUE)   # always set
    elseif(${ARG_EXEC_MODE} STREQUAL "default")
        set(default_fail            0.007)
        # set(default_failrelative    0)
        set(default_failpercent     0.02)
        set(default_hardfail        0.02)
        # set(default_allowfailures   0)
        set(default_warn            0.007)
        # set(default_warnrelative    0)
        set(default_warnpercent     0.02)
        # set(default_hardwarn        inf)
        # set(default_scale           1)
        # set(default_p               FALSE)
        # set(default_q               FALSE)
        set(default_a               TRUE)   # always set
        set(default_abs             TRUE)   # always set
        set(default_v               TRUE)   # always set
    else()
        message(FATAL_ERROR "Unrecognized EXEC_MODE: ${ARG_EXEC_MODE}")
    endif()

    # append any single-value options
    foreach(arg fail failrelative failpercent hardfail allowfailures warn warnrelative warnpercent hardwarn scale)
        set(override ARG_-${arg})
        set(default default_${arg})
        if(DEFINED ${override})
            list(APPEND args -${arg} ${${override}})
        elseif(DEFINED ${default})
            list(APPEND args -${arg} ${${default}})
        endif()
    endforeach()

    # append any flags
    foreach(arg p;q;a;abs;v)
        set(override ARG_-${arg})
        set(default default_${arg})
        if(${override})
            list(APPEND args -${arg})
        elseif(${default})
            list(APPEND args -${arg})
        endif()
    endforeach()

    set(${out_var} ${args} PARENT_SCOPE)
endfunction()

function(diff_images args canonical_image result_image)
    # cmake_path(GET canonical_image PARENT_PATH canonical_dir)
    cmake_path(GET result_image STEM stem)
    cmake_path(GET result_image EXTENSION extension)
    set(diff_image "${stem}_diff${extension}")

    execute_process(
        COMMAND ${IDIFF} ${args} -o ${diff_image} ${canonical_image} ${result_image}
        COMMAND_ECHO STDOUT
        RESULT_VARIABLE result
    )
    if(result)
        # report diff cmd args
        message("")
        string(JOIN " " idiff_args ${args})
        message("${idiff_args}")

        # report images
        set(canonical_image_full "${canonical_image}")
        set(result_image_full "${CMAKE_BINARY_DIR}/${result_image}")
        set(diff_image_full "${CMAKE_BINARY_DIR}/${diff_image}")

        cmake_path(NORMAL_PATH canonical_image_full OUTPUT_VARIABLE can)
        cmake_path(NORMAL_PATH result_image_full OUTPUT_VARIABLE res)
        cmake_path(NORMAL_PATH diff_image_full OUTPUT_VARIABLE dif)

        message("")
        message("canonical | ${can}")
        message("   result | ${res}")
        message("     diff | ${dif}")
        message("")

        message(FATAL_ERROR "Exit Code: ${result}")
    endif()
endfunction()

override_idiff_args(args EXEC_MODE ${EXEC_MODE} ${IDIFF_ARGS})
diff_images("${args}" ${CANONICAL} ${RESULT})

