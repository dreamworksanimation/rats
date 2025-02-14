# Copyright 2025 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

# =====================================================================================
# This script is run during execution of the rats tests via
#     ${CMAKE_COMMAND} -P <thisscript>.cmake -DEXAMPLE_DEF1=... -DEXAMPLE_DEF2=...
#
# It is responsible for diff'ing a pair of [canonical,result] images
# -------------------------------------------------------------------------------------
#
# Required definitions:
#   EXEC_MODE           : used to determine which defaults to use (scalar|vector|xpu)
#   CANONICAL           : path to the canonical image, .eg /some/path/to/canonicals/beauty.exr
#   RESULT              : name of the image to be compared with the canonical image, eg. beauty.exr
#   IDIFF_TOOL          : full path to the openimageio 'idiff' cmd
#   DIFF_JSON           : full path to diff.json file, which contains the args to be passed to the diff cmd
#   DIFF_DEFAULTS_JSON  : full path to diff_defaults.json file, which contains the default args to be passed to the diff cmd
# -------------------------------------------------------------------------------------
# Validate script inputs, these are required to be defined by the calling code
foreach(required_def EXEC_MODE CANONICAL RESULT IDIFF_TOOL DIFF_JSON DIFF_DEFAULTS_JSON)
    if(NOT DEFINED ${required_def})
        message(FATAL_ERROR "${required_def} is undefined")
    endif()
endforeach()
# =====================================================================================

if(NOT DEFINED ENV{RATS_CANONICAL_DIR})
    message(FATAL_ERROR "RATS_CANONICAL_DIR is undefined")
endif()

function(diff_images args canonical_image result_image)
    cmake_path(GET result_image STEM stem)
    cmake_path(GET result_image EXTENSION extension)
    set(diff_image "${stem}_diff${extension}")

    if(NOT EXISTS ${canonical_image})
        message(FATAL_ERROR "canonical not found: ${canonical_image}")
    endif()
    if(NOT EXISTS ${result_image})
        message(FATAL_ERROR "result not found: ${result_image}")
    endif()

    execute_process(
        COMMAND ${IDIFF_TOOL} ${args} -o ${diff_image} ${canonical_image} ${result_image}
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
    endif()

    # idiff returns 1 on warning and 2 on error
    if(result EQUAL 2)
        message(FATAL_ERROR "Exit Code: ${result}")
    endif()
endfunction()

# Compose a new JSON object to hold our final diff args.
set(data "{}")

# Read default diff args from json file into tmp_json string.
file(TO_NATIVE_PATH ${DIFF_DEFAULTS_JSON} diff_defaults_json_file)
if(NOT EXISTS ${diff_defaults_json_file})
    message(FATAL_ERROR "Default diff args file not found: ${diff_defaults_json_file}")
endif()
file(READ ${diff_defaults_json_file} tmp_json)
string(JSON num_entries LENGTH ${tmp_json} ${EXEC_MODE})
math(EXPR count "${num_entries}-1")
foreach(index RANGE ${count})
    string(JSON member MEMBER ${tmp_json} ${EXEC_MODE} ${index})
    string(JSON value GET ${tmp_json} ${EXEC_MODE} ${member})
    string(JSON data SET ${data} ${member} ${value})
endforeach()

# Read test-specific diff args from local diff.json, replacing any default values.
file(TO_NATIVE_PATH ${DIFF_JSON} diff_args_json_file)
if(EXISTS ${diff_args_json_file})
    file(READ ${diff_args_json_file} tmp_json)
    string(JSON object ERROR_VARIABLE err GET ${tmp_json} ${RESULT})
    if(${err} STREQUAL "NOTFOUND")
        string(JSON num_entries ERROR_VARIABLE err LENGTH ${tmp_json} ${RESULT} ${EXEC_MODE})
        if(${err} STREQUAL "NOTFOUND")
            math(EXPR count "${num_entries}-1")
            foreach(index RANGE ${count})
                string(JSON member MEMBER ${tmp_json} ${RESULT} ${EXEC_MODE} ${index})
                string(JSON value GET ${tmp_json} ${RESULT} ${EXEC_MODE} ${member})
                string(JSON data SET ${data} ${member} ${value})
            endforeach()
        endif()
    endif()
endif()

# Transform JSON data into flat list of args (key;value;key;value;flag;flag;etc.) for idiff.
set(args "")
string(JSON num_entries LENGTH ${data})
math(EXPR count "${num_entries}-1")
foreach(index RANGE ${count})
    string(JSON member MEMBER ${data} ${index})
    string(JSON value GET ${data} ${member})
    if(${member} STREQUAL "flags")
        string(JSON num_flags LENGTH ${data} ${member})
        math(EXPR flags_count "${num_flags}-1")
        foreach(flag_index RANGE ${flags_count})
            string(JSON flag GET ${data} ${member} ${flag_index})
            list(APPEND args ${flag})
        endforeach()
    else()
        list(APPEND args ${member} ${value})
    endif()
endforeach()

file(TO_NATIVE_PATH "$ENV{RATS_CANONICAL_DIR}/${CANONICAL}" full_canonical_path)
diff_images("${args}" ${full_canonical_path} ${RESULT})

