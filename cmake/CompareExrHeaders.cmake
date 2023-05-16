# Copyright 2023 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

# CANONICAL_EXR
# RESULT_EXR

macro(run_exrheader exr_file output_var)
    execute_process(
        COMMAND ${EXRHEADER} ${exr_file}
        RESULT_VARIABLE result
        OUTPUT_VARIABLE ${output_var}
        COMMAND_ECHO STDOUT
        # ECHO_OUTPUT_VARIABLE
        ECHO_ERROR_VARIABLE
    )
    if(result)
        message(FATAL_ERROR "${result}")
    endif()
endmacro()

macro(split_resume_history header_in header_out json_out)
    set(resume_history_pattern "(resumeHistory \\(type string\\): \"{)(.*)(}\")")

    # find it and store it in the json var
    string(REGEX MATCH ${resume_history_pattern} resume_history ${header_in})

    if(DEFINED resume_history)
        # capture the JSON stored in the resumeHistory field
        string(REGEX REPLACE "(resumeHistory \\(type string\\): \")(.*)(\"$)" "\\2" ${json_out} ${resume_history})

        # strip the resumeHistory field from the canonical header
        string(REGEX REPLACE "(.*)(${resume_history_pattern})(.*)" "\\1\\6" ${header_out} ${header_in})
    endif()
endmacro()

macro(filter_header header_in header_out)
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

if(EXISTS ${CANONICAL_EXR} AND EXISTS ${RESULT_EXR})
    run_exrheader(${CANONICAL_EXR} canonical_header)
    run_exrheader(${RESULT_EXR} result_header)

    split_resume_history(${canonical_header} canonical_header canonical_json)
    split_resume_history(${result_header} result_header result_json)

    filter_header(${canonical_header} canonical_header_filtered)
    filter_header(${result_header} result_header_filtered)

    message("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@\n")
    message("${canonical_json}")
    message("%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%\n")
    message("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@\n")
    message("${canonical_header_filtered}")
    message("%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%\n")
else()
    message(FATAL_ERROR "canonical or result not found")
endif()
