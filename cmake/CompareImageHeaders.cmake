# Copyright 2023 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

# =====================================================================================
# This script is run during execution of the rats tests via
#     ${CMAKE_COMMAND} -P <thisscript>.cmake -DEXAMPLE_DEF1=... -DEXAMPLE_DEF2=...
#
# It is responsible for diff'ing the headers of a pair of [canonical,result] images
# -------------------------------------------------------------------------------------
#
# Required definitions:
#   CANONICAL           : path to the canonical image, .eg /some/path/to/canonicals/beauty.exr
#   RESULT              : name of the result image, eg. beauty.exr
#   OIIOTOOL            : full path to the openimageio 'oiitool' cmd
# -------------------------------------------------------------------------------------
# Validate script inputs, these are required to be defined by the calling code
foreach(required_def CANONICAL RESULT OIIOTOOL)
    if(NOT DEFINED ${required_def})
        message(FATAL_ERROR "${required_def} is undefined")
    endif()
endforeach()
# =====================================================================================

if(NOT DEFINED ENV{RATS_CANONICAL_DIR})
    message(FATAL_ERROR "RATS_CANONICAL_DIR is undefined")
endif()

# Run 'oiiotool' and try to retrieve resumeHistory metadata from header
function(get_resume_history file output_var)
    execute_process(
        COMMAND ${OIIOTOOL} -n --info -v --metamatch "resumeHistory" -i ${file}
        RESULT_VARIABLE result
        OUTPUT_VARIABLE out
    )
    if(result)
        message(FATAL_ERROR "Exit Code: ${result}")
    endif()

    if(NOT ${out} MATCHES "resumeHistory")
        # no resumeHistory key in this header's metadata
        return()
    endif()

    # capture the value of the resumeHistory metadata key
    string(REGEX REPLACE ".*resumeHistory: \"(.*)\"" "\\1" out ${out})

    # replace escaped \n and \"
    string(REPLACE "\\n" "\n" out ${out})
    string(REPLACE "\\\"" "\"" out ${out})

    # remove fields from the JSON data that we don't want to compare
    string(JSON out REMOVE ${out} "history" 0 "sampling")
    string(JSON out REMOVE ${out} "history" 0 "execEnv")
    string(JSON out REMOVE ${out} "history" 0 "timingSummary")
    string(JSON out REMOVE ${out} "history" 0 "timingDetail" "procStartTime")
    string(JSON out REMOVE ${out} "history" 0 "timingDetail" "frameStartTime")
    string(JSON mcrt_length LENGTH ${out} "history" 0 "timingDetail" "MCRT")
    math(EXPR mcrt_length_last_index ${mcrt_length}-1)
    foreach(i RANGE 0 ${mcrt_length_last_index})
        string(JSON out REMOVE ${out} "history" 0 "timingDetail" "MCRT" ${i} "MCRTStartTime")
        string(JSON out REMOVE ${out} "history" 0 "timingDetail" "MCRT" ${i} "MCRTEndTime")
    endforeach()

    set(${output_var} ${out} PARENT_SCOPE)
endfunction()

#------------------------------------

# Run 'oiiotool' and filter out filename, resumeHistory and DateTime metadata from header
function(get_header file output_var)
    execute_process(
        COMMAND ${OIIOTOOL} -n --info -v --no-metamatch "resumeHistory|DateTime" -i ${file}
        RESULT_VARIABLE result
        OUTPUT_VARIABLE out
        ECHO_ERROR_VARIABLE
    )
    if(result)
        message(FATAL_ERROR "Exit Code: ${result}")
    endif()

    # strip the "Reading <filename>" etc.. everything up to first " :  "
    string(REGEX REPLACE ".* :  (.*)" "\\1" out ${out})

    set(${output_var} ${out} PARENT_SCOPE)
endfunction()

#------------------------------------

file(TO_NATIVE_PATH "$ENV{RATS_CANONICAL_DIR}/${CANONICAL}" full_canonical_path)

# Execute the header/metatdata comparison
if(NOT EXISTS ${full_canonical_path})
    message(FATAL_ERROR "canonical not found: ${full_canonical_path}")
endif()
if(NOT EXISTS ${RESULT})
    message(FATAL_ERROR "result not found: ${RESULT}")
endif()

# first, compare the resumeHistory metadata if it exists
get_resume_history(${full_canonical_path} canonical_history)
get_resume_history(${RESULT} result_history)

if(DEFINED canonical_history OR DEFINED result_history)
    string(JSON same EQUAL ${canonical_history} ${result_history})
    if(NOT same)
        cmake_path(GET RESULT STEM stem)
        set(json_file_1 ${stem}_canonical_resumeHistory.json)
        set(json_file_2 ${stem}_result_resumeHistory.json)
        file(WRITE ${json_file_1} ${canonical_history})
        file(WRITE ${json_file_2} ${result_history})
        message("headers have different \"resumeHistory\" metadata:")
        message("    ${CMAKE_CURRENT_BINARY_DIR}/${json_file_1}")
        message("    ${CMAKE_CURRENT_BINARY_DIR}/${json_file_2}")
        message(FATAL_ERROR "")
    endif()
endif()

# next, compare the remaining header information
get_header(${canonical_expanded} canonical_header)
get_header(${RESULT} result_header)

if(NOT ${canonical_header} STREQUAL ${result_header})
    cmake_path(GET RESULT STEM stem)
    set(header_file_1 ${stem}_canonical_header.txt)
    set(header_file_2 ${stem}_result_header.txt)
    file(WRITE ${header_file_1} ${canonical_history})
    file(WRITE ${header_file_2} ${result_history})
    message("headers are different:")
    message("    ${full_canonical_path}")
    message("    ${RESULT}")
    message(FATAL_ERROR "")
endif()

