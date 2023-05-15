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

if(EXISTS ${CANONICAL_EXR} AND EXISTS ${RESULT_EXR})
    run_exrheader(${CANONICAL_EXR} canonical_header)
    run_exrheader(${RESULT_EXR} result_header)

    # strip out and save our custom JSON content from the header string, if found

    # this pattern matches the chunk of the header containing the resumeHistory field
    set(resume_history_pattern "(resumeHistory \\(type string\\): \"{)(.*)(}\")")

    # find it and store it in the json var
    string(REGEX MATCH ${resume_history_pattern} resume_history ${canonical_header})
    if(DEFINED resume_history)

        # strip the 'resumeHistory' exr header field keeping only what's inside
        # (we want only the actual JSON data stored within the field)
        string(REGEX REPLACE "(resumeHistory \\(type string\\): \")(.*)(\"$)" "\\2" json ${resume_history})

        string(REGEX REPLACE "(.*)(${resume_history_pattern})(.*)" "\\1\\6" out ${canonical_header})

        # turn what's left of the header into a list so we can filter line by line
        # keeping only the fields we want
        string(REPLACE "\n" ";" canonical_header_lines ${out})
        set(canonical_header_filtered "")
        foreach(line ${canonical_header_lines})
            # strip opening "file /path/to/file.exr" line since it will be different
            # between the canonical and the current result
            if(line MATCHES "^file (.*)exr:$")
                continue()
            endif()

            # strip "capDate" line it contains a timestamp
            if(line MATCHES "^capDate")
                continue()
            endif()

            string(APPEND canonical_header_filtered "${line}\n")
        endforeach()

        message("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@\n")
        message("${json}")
        message("%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%\n")
        message("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@\n")
        message("${canonical_header_filtered}")
        message("%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%\n")
    endif()
else()
    message(FATAL_ERROR "canonical or result not found")
endif()
