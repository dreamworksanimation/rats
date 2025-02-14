# Copyright 2025 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

# =====================================================================================
# This script is run during execution of the rats tests via
#     ${CMAKE_COMMAND} -P <thisscript>.cmake -DEXAMPLE_DEF1=... -DEXAMPLE_DEF2=...
#
# It is responsible for rendering and analyzing a series of images to attempt to find
# the best candidates to become the official canonicals, copying those canonicals to
# the RATS_CANONICALS_DIR, and updating a test's diff.json with new ideal thresholds
# for the idiff cmd.
# -------------------------------------------------------------------------------------
# Validate script inputs, these are required to be defined by the calling code
foreach(required_def
    TEST_REL_PATH                   # relative test path (from RATS_CANONICAL_DIR) for canonicals.
                                    #   It will be created if necessary.
    CANONICALS                      # list of output images to be stored as canonicals, eg.
                                    #   scene.exr;aovs.exr;more_aovs.exr
    RENDER_CMD                      # fully qualified render commnd line as a list, eg:
                                    #   /path/to/moonray;-in;scene.rdla;-exec_mode;scalar
    EXEC_MODE                       # used to determine which defaults to use (scalar|vector|xpu)
    IDIFF_TOOL                      # full path to the openimageio 'idiff' cmd
    DIFF_JSON                       # full path to diff.json file, which gets updated with new thresholds at the end of this script
    DIFF_DEFAULTS_JSON)             # full path to diff_defaults.json file, which contains the default args to be passed to the diff cmd
    if(NOT DEFINED ${required_def})
        message(FATAL_ERROR "[RATS] ${required_def} is undefined")
    endif()
endforeach()
# =====================================================================================

# Validate RATS_CANONICAL_DIR
if(NOT DEFINED ENV{RATS_CANONICAL_DIR})
    message(FATAL_ERROR "[RATS] RATS_CANONICAL_DIR is undefined")
endif()
file(TO_NATIVE_PATH $ENV{RATS_CANONICAL_DIR} canonical_path)
if(NOT EXISTS ${canonical_path})
    message(FATAL_ERROR "[RATS] RATS_CANONICAL_DIR ${canonical_path} does not exist")
endif()
file(TO_NATIVE_PATH "${canonical_path}/${TEST_REL_PATH}/" full_canonical_path)

# ====================================================================================
# TODO: CMake can't handle floating point math expressions, and using bash/awk here
# is not a portable solution.  One way to solve this would be to write a custom program
# or perhaps python script to do this processing and include it in this repo.  Refer to
# MakeCanonicals.awk for details of program input/output requirements.
function(process_test_results awk_input_file awk_output_file)
    execute_process(
        COMMAND bash -c "awk -f ${CMAKE_CURRENT_FUNCTION_LIST_DIR}/MakeCanonicals.awk ${awk_input_file}"
        RESULT_VARIABLE result
        OUTPUT_FILE "${awk_output_file}"
        ECHO_OUTPUT_VARIABLE)
    if(result)
        message(FATAL_ERROR "[RATS] awk error")
    endif()
endfunction()
# ====================================================================================

# Create directory to write all temporary files
set(tmp_dir "make_canonicals_tmp")

# Compose a new JSON object to hold our final diff args.
set(default_diff_args "{}")

# Read default diff args from json file into tmp_json string.
file(TO_NATIVE_PATH ${DIFF_DEFAULTS_JSON} diff_defaults_json_file)
if(NOT EXISTS ${diff_defaults_json_file})
    message(FATAL_ERROR "[RATS] Default diff args file not found: ${diff_defaults_json_file}")
endif()
file(READ ${diff_defaults_json_file} tmp_json)
string(JSON num_entries LENGTH ${tmp_json} ${EXEC_MODE})
math(EXPR count "${num_entries}-1")
foreach(index RANGE ${count})
    string(JSON member MEMBER ${tmp_json} ${EXEC_MODE} ${index})
    string(JSON value GET ${tmp_json} ${EXEC_MODE} ${member})
    string(JSON default_diff_args SET ${default_diff_args} ${member} ${value})
endforeach()

# Transform JSON default_diff_args into flat list of args (key;value;key;value;flag;flag;etc.) for idiff.
set(diff_args_list "")
string(JSON num_entries LENGTH ${default_diff_args})
math(EXPR count "${num_entries}-1")
foreach(index RANGE ${count})
    string(JSON member MEMBER ${default_diff_args} ${index})
    string(JSON value GET ${default_diff_args} ${member})
    if(${member} STREQUAL "flags")
        string(JSON num_flags LENGTH ${default_diff_args} ${member})
        math(EXPR flags_count "${num_flags}-1")
        foreach(flag_index RANGE ${flags_count})
            string(JSON flag GET ${default_diff_args} ${member} ${flag_index})
            list(APPEND diff_args_list ${flag})
        endforeach()
    else()
        list(APPEND diff_args_list ${member} ${value})
    endif()
endforeach()

# Executes a command and checks return value
# TODO: this function isn't really needed anymore, just call execute_process() directly
function(exec_and_check)
    set(options "")
    set(oneValueArgs
        WORKING_DIRECTORY
    )
    set(multiValueArgs
        COMMAND
    )

    # parse and validate arguments
    cmake_parse_arguments(ARG "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})
    if(DEFINED ARG_KEYWORDS_MISSING_VALUES)
        message(FATAL_ERROR "[RATS] Keywords missing values: ${ARG_KEYWORDS_MISSING_VALUES}")
    endif()
    if(DEFINED ARG_UNPARSED_ARGUMENTS)
        message(FATAL_ERROR "[RATS] Unrecognized arguments: ${ARG_UNPARSED_ARGUMENTS}")
    endif()
    if(NOT DEFINED ARG_COMMAND)
        message(FATAL_ERROR "[RATS] You must specify COMMAND")
    endif()
    list(POP_FRONT args cmd)

    set(args ${ARG_COMMAND})
    list(POP_FRONT ${args} cmd)
    execute_process(
        COMMAND ${cmd} ${args}
        WORKING_DIRECTORY ${ARG_WORKING_DIRECTORY}
        RESULT_VARIABLE result
        COMMAND_ECHO STDOUT
        ECHO_OUTPUT_VARIABLE
        ECHO_ERROR_VARIABLE
    )
    if(result)
        message(FATAL_ERROR "[RATS] ${cmd} ${args} ${result}")
    endif()
endfunction()

function(parse_idiff_output)
    set(options "")
    set(oneValueArgs
        IDIFF_OUTPUT                # the output from the idiff cmd
        MEAN_ERROR_VARIABLE         # output var to store Mean error result
        MAX_ERROR_VARIABLE          # output var to store Max error result
        PEAK_SNR_VARIABLE           # output var to store Peak SNR result
        RMS_ERROR_VARIABLE          # output var to store RMS error result
        PIXELS_WARNING_VARIABLE     # output var to store number of pixels over the warning threshold
        PIXELS_ERROR_VARIABLE       # output var to store number of pixels over the error threshold
    )
    set(multiValueArgs "")

    # parse and validate arguments
    cmake_parse_arguments(ARG "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})
    if(DEFINED ARG_KEYWORDS_MISSING_VALUES)
        message(FATAL_ERROR "[RATS] Keywords missing values: ${ARG_KEYWORDS_MISSING_VALUES}")
    endif()
    if(DEFINED ARG_UNPARSED_ARGUMENTS)
        message(FATAL_ERROR "[RATS] Unrecognized arguments: ${ARG_UNPARSED_ARGUMENTS}")
    endif()
    foreach(arg ${oneValueArgs})
        if(NOT DEFINED ARG_${arg})
            message(FATAL_ERROR "[RATS] You must specify ${arg}")
        endif()
    endforeach()

    # CMake has very limited REGEX support, not sure if this is sufficiently robust
    set(number_pattern "(inf|[0-9]+\\.?[0-9]*e?[+-]?[0-9]*)")
    string(REGEX MATCH "Mean error = ${number_pattern}" mean "${ARG_IDIFF_OUTPUT}")
    set(${ARG_MEAN_ERROR_VARIABLE} ${CMAKE_MATCH_1} PARENT_SCOPE)
    string(REGEX MATCH "Max error  = ${number_pattern}" max  "${ARG_IDIFF_OUTPUT}")
    set(${ARG_MAX_ERROR_VARIABLE} ${CMAKE_MATCH_1}  PARENT_SCOPE)
    string(REGEX MATCH "Peak SNR = ${number_pattern}" peak "${ARG_IDIFF_OUTPUT}")
    set(${ARG_PEAK_SNR_VARIABLE}   ${CMAKE_MATCH_1} PARENT_SCOPE)
    string(REGEX MATCH "RMS error = ${number_pattern}" rms "${ARG_IDIFF_OUTPUT}")
    set(${ARG_RMS_ERROR_VARIABLE} ${CMAKE_MATCH_1} PARENT_SCOPE)
    string(REGEX MATCHALL "  [0-9]+ pixels" pixels_matches ${ARG_IDIFF_OUTPUT})
    list(POP_FRONT pixels_matches match1)
    list(POP_FRONT pixels_matches match2)
    string(REGEX MATCH "  ([0-9]+) pixels" res ${match1})
    set(${ARG_PIXELS_WARNING_VARIABLE} ${CMAKE_MATCH_1} PARENT_SCOPE)
    string(REGEX MATCH "  ([0-9]+) pixels" res ${match2})
    set(${ARG_PIXELS_ERROR_VARIABLE} ${CMAKE_MATCH_1} PARENT_SCOPE)
endfunction()

# Render N sets of candidate canonicals in the build dir.
set(N 24)
math(EXPR N_minus_one "${N}-1")

# Execute renders
foreach(i RANGE ${N_minus_one})
    set(working_dir ${tmp_dir}/${i})
    file(MAKE_DIRECTORY ${working_dir})
    exec_and_check(COMMAND ${RENDER_CMD} WORKING_DIRECTORY ${working_dir})
    math(EXPR current_render "${i}+1")
    message("[RATS] Finished canonical candidate render ${current_render}/${N}")
endforeach()

# Run image diffs and capture statistics.  We will run the idiff tool to compare each
# candidate with all the other candidates, and store the results in a human-readable
# JSON object, as well as an awk-friendly list of records (lines).
set(diff_results "{}")      # JSON structure for human readability
set(awk_input "")           # Flat list of lines to serve as awk input

list(LENGTH CANONICALS num_canonicals)
set(current_canonical 1)
foreach(image_filename ${CANONICALS})
    set(num_diffs 0)
    set(num_copies 0)
    set(num_empties 0)
    set(image_object "{}")

    foreach(i RANGE ${N_minus_one})
        set(candidate_key "${i}")
        set(candidate_object "{}")

        set(max_error_record      ${image_filename} "${candidate_key}" "max_error")
        set(mean_error_record     ${image_filename} "${candidate_key}" "mean_error")
        set(peak_snr_record       ${image_filename} "${candidate_key}" "peak_snr")
        set(rms_error_record      ${image_filename} "${candidate_key}" "rms_error")
        set(pixels_warning_record ${image_filename} "${candidate_key}" "pixels_warning")
        set(pixels_error_record   ${image_filename} "${candidate_key}" "pixels_error")

        set(candidate_image ${tmp_dir}/${i}/${image_filename})
        foreach(j RANGE ${N_minus_one})
            set(test_key "${j}")
            set(test_object "{}")
            set(test_image ${tmp_dir}/${j}/${image_filename})
            if (${i} STREQUAL ${j})
                message("[RATS] Skipping diff for ${candidate_key}-${test_key}")
                math(EXPR num_empties "${num_empties}+1")
            elseif (${i} GREATER ${j})
                # Optimization: we've already diff'd these two images, copy previous results by swapping keys
                message("[RATS] Copying previous diff results for ${candidate_key}-${test_key} from ${test_key}-${candidate_key}")
                string(JSON test_object GET ${image_object} "${test_key}" "${candidate_key}")
                math(EXPR num_copies "${num_copies}+1")
            else()
                # do idiff
                set(this_diff_args ${diff_args_list})
                list(APPEND this_diff_args ${candidate_image} ${test_image})
                list(JOIN this_diff_args " " args)

                execute_process(
                    COMMAND ${IDIFF_TOOL} ${this_diff_args}
                    RESULT_VARIABLE result
                    COMMAND_ECHO STDOUT
                    OUTPUT_VARIABLE out
                    ECHO_OUTPUT_VARIABLE
                    ECHO_ERROR_VARIABLE
                )

                # Strip any semicolons from idiff's output, otherwise CMake will split the string
                # into list tokens when we pass it as a function argument.
                string(REPLACE ";" "|" out "${out}")

                # Parse idiff output and build a database of results
                parse_idiff_output(IDIFF_OUTPUT "${out}"
                    MAX_ERROR_VARIABLE max_error
                    MEAN_ERROR_VARIABLE mean_error
                    PEAK_SNR_VARIABLE peak_snr
                    RMS_ERROR_VARIABLE rms_error
                    PIXELS_WARNING_VARIABLE pixels_warning
                    PIXELS_ERROR_VARIABLE pixels_error)

                # write the stats for this diff to the database
                string(JSON test_object SET ${test_object} "max_error"      \"${max_error}\")
                string(JSON test_object SET ${test_object} "mean_error"     \"${mean_error}\")
                string(JSON test_object SET ${test_object} "peak_snr"       \"${peak_snr}\")
                string(JSON test_object SET ${test_object} "rms_error"      \"${rms_error}\")
                string(JSON test_object SET ${test_object} "pixels_warning" \"${pixels_warning}\")
                string(JSON test_object SET ${test_object} "pixels_error"   \"${pixels_error}\")
                math(EXPR num_diffs "${num_diffs}+1")

                # Append the value to our lists
                list(APPEND max_error_record      ${max_error})
                list(APPEND mean_error_record     ${mean_error})
                list(APPEND peak_snr_record       ${peak_snr})
                list(APPEND rms_error_record      ${rms_error})
                list(APPEND pixels_warning_record ${pixels_warning})
                list(APPEND pixels_error_record   ${pixels_error})
            endif()
            # Add test_object to this candidate_object
            string(JSON candidate_object SET ${candidate_object} ${test_key} ${test_object})
        endforeach() # j

        # Add each line to our final output string
        string(APPEND awk_input "${max_error_record}\n")
        string(APPEND awk_input "${mean_error_record}\n")
        string(APPEND awk_input "${peak_snr_record}\n")
        string(APPEND awk_input "${rms_error_record}\n")
        string(APPEND awk_input "${pixels_warning_record}\n")
        string(APPEND awk_input "${pixels_error_record}\n")

        # Add candidate_object to this image_object
        string(JSON image_object SET ${image_object} ${candidate_key} ${candidate_object})
    endforeach() # i
    # Add image_object to our top-level JSON object
    string(JSON diff_results SET ${diff_results} ${image_filename} ${image_object})

    message("[RATS] Finished ${N} diffs for canonical ${image_filename} (${current_canonical}/${num_canonicals} canonicals for test ${TEST_REL_PATH}.)")
    math(EXPR current_canonical "${current_canonical}+1")
    message("\n[RATS] ${num_diffs} unique diffs performed.")
    message("[RATS] ${num_copies} copies performed.")
    message("[RATS] ${num_empties} diffs skipped (self-comparisons).\n")
endforeach() # image_filename

set(diff_results_file "diff_results.json")
file(WRITE ${diff_results_file} ${diff_results})
message("[RATS] Wrote diff results to ${diff_results_file}")

# Write file with all of the idiff results to be used as input to awk.
set(awk_input_file "awk_input.txt")
file(WRITE ${awk_input_file} "${awk_input}")
message("[RATS] Wrote awk input to ${awk_input_file}")

# Run the awk cmd to analyze test results
set(awk_output_file "awk_output.json")
process_test_results("${awk_input_file}" "${awk_output_file}")
message("[RATS] Wrote awk ouput to ${awk_output_file}")

# Read in the output of our awk script.
file(READ ${awk_output_file} awk_output)

# For each canonical image
foreach(image_filename ${CANONICALS})
    # Report the best candidate (index)
    string(JSON candidate_index GET ${awk_output} ${image_filename} "best candidate")
    message("[RATS] ${image_filename}: best candidate is ${candidate_index}")

    # Copy best candidate's canonicals to the RATS_CANONICALS directory, this is
    # our new canonical, assuming the file is eventually committed/merged.
    set(candidate_dir "${tmp_dir}/${candidate_index}")
    set(mkdir_cmd ${CMAKE_COMMAND} -E make_directory "${full_canonical_path}")
    exec_and_check(COMMAND ${mkdir_cmd} WORKING_DIRECTORY ${candidate_dir})
    set(copy_cmd ${CMAKE_COMMAND} -E copy "${image_filename}" "${full_canonical_path}")
    exec_and_check(COMMAND ${copy_cmd} WORKING_DIRECTORY ${candidate_dir})
    message("[RATS] Copied canonical from ${candidate_dir}/${image_filename}\n")

    string(JSON diff_args GET ${awk_output} ${image_filename} "diff args")
    file(TO_NATIVE_PATH ${DIFF_JSON} diff_json_file)

    # Attempt to read existing diff.json file for this particular test.
    # We need to update the thresholds for this image and exec_mode using
    # the stats we have just analyzed.
    if (EXISTS ${diff_json_file})
        # Load the JSON file from disk
        file(READ ${diff_json_file} diff_json)

        # Check for the existence of the canonical/image_filename object,
        # and insert an empty one if needed
        string(JSON throwaway ERROR_VARIABLE err GET ${diff_json} ${image_filename})
        if (err)
            string(JSON diff_json SET ${diff_json} ${image_filename} "{}")
        endif()

        # Replace diff args for this execution mode
        string(JSON diff_json ERROR_VARIABLE err SET ${diff_json} ${image_filename} ${EXEC_MODE} ${diff_args})
        if (err)
            string(JSON diff_json SET ${diff_json} ${image_filename} "{}")
        endif()
    else()
        # Otherwise create new JSON objects
        string(JSON diff_json SET "{}" ${image_filename} "{}")
        string(JSON diff_json SET ${diff_json} ${image_filename} ${EXEC_MODE} ${diff_args})
        if (err)
            string(JSON diff_json SET ${diff_json} ${image_filename} "{}")
        endif()
    endif()

    # Write the updated JSON to disk.  This will become the new idiff thresholds for
    # this test/exec_mode, assuming this file is eventually committed/merged.
    file(WRITE ${diff_json_file} ${diff_json})
    message("[RATS] Wrote updated idiff args for image ${image_filename}, exec_mode ${EXEC_MODE} to file ${diff_json_file}")
endforeach()

# cleanup tmp dir, which contains all of the candidate canonicals.
file(REMOVE_RECURSE ${tmp_dir})

# We'll leave the following files in the build directory for this test, since they are
# relatively small and may be useful/interesting for reviewing/debugging.  Should we
# decide they are not needed we could simply create them within the ${tmp_dir} rather
# than at the root.
#   diff_results.json       <-- all idiff results in human-readable JSON format
#   awk_input.json          <-- this same data in awk-friendly format, one line at a time
#   awk_output.json         <-- the analytics from awk in human/cmake-readable JSON format
