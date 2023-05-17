# Copyright 2023 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

# -------------------------------------------------------------------------------------
# This script is during execution of the rats tests and is responsible for comparing
# the headers of the canonical and rendered .exr images.
# It expects to be run with the following variables defined:
#   CANONCAL_EXR    : the fully qualified path to the canonical .exr
#   RESULT_EXR      : the relative path to the result .exr
# -------------------------------------------------------------------------------------

# Run 'oiiotool' and try to retrieve resumeHistory metadata from exr header
function(get_resume_history exr_file output_var)
    execute_process(
        COMMAND ${OIIOTOOL} -n --info -v --metamatch "resumeHistory" -i ${exr_file}
        RESULT_VARIABLE result
        OUTPUT_VARIABLE out
        ECHO_ERROR_VARIABLE
    )
    if(result)
        message(FATAL_ERROR "${result}")
    endif()

    if(NOT ${out} MATCHES "resumeHistory")
        # no resumeHistory key in this .exr header's metadata
        return()
    endif()

    # capture the value of the resumeHistory metadata key
    string(REGEX REPLACE ".*resumeHistory: \"(.*)\"" "\\1" out ${out})

    # replace escaped \n and \"
    string(REPLACE "\\n" "\n" out ${out})
    string(REPLACE "\\\"" "\"" out ${out})

    # remove fields from the JSON data that we don't want to compare
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

# Run 'oiiotool' and filter out filename, resumeHistory and DateTime metadata from exr header
function(get_header exr_file output_var)
    execute_process(
        COMMAND ${OIIOTOOL} -n --info -v --no-metamatch "resumeHistory|DateTime" -i ${exr_file}
        RESULT_VARIABLE result
        OUTPUT_VARIABLE out
        ECHO_ERROR_VARIABLE
    )
    if(result)
        message(FATAL_ERROR "${result}")
    endif()

    # strip the "Reading <filename>" etc.. everything up to first " :  "
    string(REGEX REPLACE ".* :  (.*)" "\\1" out ${out})

    set(${output_var} ${out} PARENT_SCOPE)
endfunction()

#------------------------------------

# Execute the exr header/metatdata comparison
if(EXISTS ${CANONICAL_EXR} AND EXISTS ${RESULT_EXR})
    # first, compare the resumeHistory metadata if it exists
    get_resume_history(${CANONICAL_EXR} canonical_history)
    get_resume_history(${RESULT_EXR} result_history)

    if(DEFINED canonical_history OR DEFINED result_history)
        string(JSON same EQUAL ${canonical_history} ${result_history})
        if(NOT same)
            message(FATAL_ERROR "exr headers have different \"resumeHistory\" metadata")
        endif()
    endif()

    # next, compare the remaining header information
    get_header(${CANONICAL_EXR} canonical_header)
    get_header(${RESULT_EXR} result_header)

    if(NOT ${canonical_header} STREQUAL ${result_header})
        message(FATAL_ERROR "exr headers are different")
    endif()
else()
    message(FATAL_ERROR "canonical or result not found")
endif()

