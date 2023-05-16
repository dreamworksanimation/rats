# Copyright 2023 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

# -------------------------------------------------------------------------------------
# This script is during execution of the rats tests and is responsible for comparing
# the headers of the canonical and rendered .exr images.
# It expects to be run with the following variables defined:
#   CANONCAL_EXR    : the fully qualified path to the canonical .exr
#   RESULT_EXR      : the relative path to the result .exr
# -------------------------------------------------------------------------------------

# Run 'exrheader' and retrieve the output
macro(_get_header exr_file output_var)
    execute_process(
        COMMAND ${EXRHEADER} ${exr_file}
        RESULT_VARIABLE result
        OUTPUT_VARIABLE ${output_var}
        COMMAND_ECHO STDOUT
        ECHO_ERROR_VARIABLE
    )
    if(result)
        message(FATAL_ERROR "${result}")
    endif()
endmacro()

# Split the output of exrheader into two parts:
#   json_out        : the contents of the "resumeHistory" key in JSON format, otherwise undefined
#   header_out      : the remainder of the header with the "resumeHistory"
#                     key/value stripped out
macro(_split_header header_in header_out json_out)
    set(resume_history_pattern "(resumeHistory \\(type string\\): \"{)(.*)(}\")")

    # find it and store it in the json var
    string(REGEX MATCH ${resume_history_pattern} resume_history ${header_in})

    if(resume_history)
        # capture the JSON stored in the resumeHistory field
        string(REGEX REPLACE "(resumeHistory \\(type string\\): \")(.*)(\"$)" "\\2" ${json_out} ${resume_history})

        # strip the resumeHistory field from the canonical header
        string(REGEX REPLACE "(.*)(${resume_history_pattern})(.*)" "\\1\\6" ${header_out} ${header_in})
    else()
        set(${header_out} ${header_in})
    endif()
endmacro()

# Filter the contents of the exrheader output to remove anything that
# isn't suitable for comparison (image name, timestamps, etc.)
macro(_filter_header header_in header_out)
    # turn the header into a list so we can filter line by line
    string(REPLACE "\n" ";" header_lines ${header_in})

    set(${header_out} "")
    foreach(line ${header_lines})
        # strip blank lines
        if(NOT line)
            continue()
        endif()

        # strip opening "file /path/to/file.exr" line since it will be different for each header
        if(line MATCHES "^file (.*)exr:$")
            continue()
        endif()

        # strip "capDate" line because it contains a timestamp and will always be different
        if(line MATCHES "^capDate")
            continue()
        endif()

        string(APPEND ${header_out} "${line}\n")
    endforeach()
endmacro()

# Remove all of the timing/timestamp info from the 'resumeHistory' JSON value
function(_filter_json json_in json_out)
    set(out ${json_in})
    string(JSON out REMOVE ${out} "history" 0 "execEnv")
    string(JSON out REMOVE ${out} "history" 0 "timingSummary")
    string(JSON out REMOVE ${out} "history" 0 "timingDetail" "procStartTime")
    string(JSON out REMOVE ${out} "history" 0 "timingDetail" "frameStartTime")

    string(JSON mcrt_length LENGTH ${json_in} "history" 0 "timingDetail" "MCRT")
    # oof, CMake, really?
    math(EXPR mcrt_length_last_index ${mcrt_length}-1)
    foreach(i RANGE 0 ${mcrt_length_last_index})
        string(JSON out REMOVE ${out} "history" 0 "timingDetail" "MCRT" ${i} "MCRTStartTime")
        string(JSON out REMOVE ${out} "history" 0 "timingDetail" "MCRT" ${i} "MCRTEndTime")
    endforeach()

    set(${json_out} ${out} PARENT_SCOPE)

endfunction()

# Execute the exrheader comparison
if(EXISTS ${CANONICAL_EXR} AND EXISTS ${RESULT_EXR})
    _get_header(${CANONICAL_EXR} canonical_header)
    _split_header(${canonical_header} canonical_header canonical_json)
    _filter_header(${canonical_header} canonical_header_filtered)
    if(canonical_json)
        _filter_json("${canonical_json}" canonical_json)
    endif()

    _get_header(${RESULT_EXR} result_header)
    _split_header(${result_header} result_header result_json)
    _filter_header(${result_header} result_header_filtered)
    if(result_json)
        _filter_json("${result_json}" result_json)
    endif()

    if(canonical_json OR result_json)
        string(JSON same EQUAL ${canonical_json} ${result_json})
        if(NOT same)
            message(FATAL_ERROR "exr headers have different \"resumeHistory\" metadata")
        endif()
    endif()

    if(NOT ${canonical_header_filtered} STREQUAL ${result_header_filtered})
        message(FATAL_ERROR "exr headers are different")
    endif()
else()
    message(FATAL_ERROR "canonical or result not found")
endif()

