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
    IDIFF                           # full path to the openimageio 'idiff' cmd
    DIFF_JSON                       # relative path to diff.json file to be created/updated with diff args
    PYTHON_EXECUTABLE)              # full path to python executable
    if(NOT DEFINED ${required_def})
        message(FATAL_ERROR "[RATS] ${required_def} is undefined")
    endif()
endforeach()

# Validate RATS_CANONICAL_DIR
if(NOT DEFINED ENV{RATS_CANONICAL_DIR})
    message(FATAL_ERROR "[RATS] RATS_CANONICAL_DIR is undefined")
endif()
file(TO_NATIVE_PATH $ENV{RATS_CANONICAL_DIR} canonicals_root)
if(NOT EXISTS ${canonicals_root})
    message(FATAL_ERROR "[RATS] RATS_CANONICAL_DIR ${canonicals_root} does not exist")
endif()
file(TO_NATIVE_PATH "${canonicals_root}/${TEST_REL_PATH}/${EXEC_MODE}/" full_canonical_path)

# ====================================================================================
# TODO: CMake can't handle floating point math expressions, and using bash/awk here
# is not a portable solution.  One way to solve this would be to write a custom program
# or perhaps python script to do this processing and include it in this repo.  Refer to
# analyze_diffs.awk for details of program input/output requirements.
function(process_test_results awk_input_file awk_output_file)
    execute_process(
        COMMAND bash -c "awk -f ${CMAKE_CURRENT_FUNCTION_LIST_DIR}/analyze_diff_stats.awk ${awk_input_file}"
        RESULT_VARIABLE result
        OUTPUT_FILE "${awk_output_file}"
        ECHO_OUTPUT_VARIABLE)
    if(result)
        message(FATAL_ERROR "[RATS] awk error")
    endif()
endfunction()
# ====================================================================================

# Create directory to write all temporary files
set(tmp_dir "update_canonicals_tmp")
set(awk_input_file "awk_input.txt")

# Executes a command and checks return value
# TODO: this function isn't particularly useful, just call execute_process() directly
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

# Render N sets of candidate canonicals in the build dir.
set(N 25)
math(EXPR N_minus_one "${N}-1")

# This 'debugging' variable allows us to bypass the following steps:
# 1) the rendering of the candidate images
# 2) the diff'ing of the candidate images to gather statistics
# 3) the copying of the best candidate to the canonicals directory
#
# When this is set to OFF we skip to the step where we analyze the
# results and choose idiff heuristics and update the diff.json file.
# This can be useful for iterating/testing different heuristics,
# but be aware that it requires that you have already run all of the
# steps once and that there exists a file called awk_input.txt in
# the build directory.
set(generate_new_canonical ON)

if(generate_new_canonical)
    # Execute renders
    foreach(i RANGE ${N_minus_one})
        set(working_dir ${tmp_dir}/${i})
        file(MAKE_DIRECTORY ${working_dir})
        exec_and_check(COMMAND ${RENDER_CMD} WORKING_DIRECTORY ${working_dir})
        math(EXPR current_render "${i}+1")
        message("[RATS] Finished canonical candidate render ${current_render}/${N}")
    endforeach()

    file(WRITE ${awk_input_file} "Num tests: ${N_minus_one}\n")

    # Compare each candidate with all the other candidates.
    # For each canonical image:
    # For each candidate pair:
    # 1. Run idiff, capturing the output, as well as generating an absolute difference image
    # 2. Run iinfo --stats on the difference image, capturing the output
    # 3. We'll store the results in a JSON structure indexed by canonical image, candidate pair
    # The following conditions require special handling:
    # a) the candidate 'pair' is actually the same image: Do nothing (Skip steps 1, 2, 3)
    # b) the candidate pair has already been tested: Skip steps 1, 2, copy previous data for step 3

    set(diff_args_list "-a;-abs;-v")
    set(diff_results_json "{}")
    list(LENGTH CANONICALS num_canonicals)
    set(current_canonical 1)
    foreach(image_key ${CANONICALS})
        set(num_diffs 0)
        set(num_copies 0)
        set(num_empties 0)
        set(image_json "{}")
        set(image_str "")
        cmake_path(GET image_key STEM stem)
        cmake_path(GET image_key EXTENSION extension)
        string(APPEND image_str "Image: ${image_key}\n")

        foreach(i RANGE ${N_minus_one})
            set(candidate_key "${i}")
            set(candidate_image ${tmp_dir}/${i}/${image_key})
            set(candidate_json "{}")
            string(APPEND image_str "Candidate: ${i}\n")

            foreach(j RANGE ${N_minus_one})
                set(test_key "${j}")
                set(test_image ${tmp_dir}/${j}/${image_key})
                if (${i} STREQUAL ${j})
                    message("[RATS] Skipping diff for ${candidate_key}-${test_key}")
                    math(EXPR num_empties "${num_empties}+1")
                    continue()
                endif()

                string(APPEND image_str "Test: ${j}\n")
                if (${i} GREATER ${j})
                    # Optimization: we've already diff'd these two images, copy previous results by swapping keys
                    message("[RATS] Copying previous diff results for ${candidate_key}-${test_key} from ${test_key}-${candidate_key}")
                    string(JSON previous_results GET "${image_json}" "${test_key}" "${candidate_key}")

                    # Escape quotes to preserve them when they are written to JSON
                    string(REPLACE "\"" "\\\"" previous_results "${previous_results}")
                    string(REPLACE ";" "" previous_results "${previous_results}")

                    string(JSON candidate_json SET "${candidate_json}" ${test_key} \"${previous_results}\")
                    string(APPEND image_str "${previous_results}")

                    math(EXPR num_copies "${num_copies}+1")
                else()
                    # do idiff
                    set(diff_image "${tmp_dir}/${i}/${stem}.diff.${j}${extension}")
                    set(this_diff_args ${diff_args_list})
                    list(APPEND this_diff_args ${candidate_image} ${test_image} -o ${diff_image})
                    list(JOIN this_diff_args " " args)
                    execute_process(
                        COMMAND ${IDIFF} ${this_diff_args}
                        RESULT_VARIABLE result
                        COMMAND_ECHO STDOUT
                        OUTPUT_VARIABLE out1
                        ECHO_OUTPUT_VARIABLE
                        ECHO_ERROR_VARIABLE
                    )

                    # Print openimageio stats on diff image
                    set(oiio_stats_cmd ${CMAKE_CURRENT_LIST_DIR}/oiio_stats.py ${diff_image})
                    execute_process(
                        COMMAND python ${oiio_stats_cmd}
                        RESULT_VARIABLE result
                        COMMAND_ECHO STDOUT
                        OUTPUT_VARIABLE out2
                        ECHO_OUTPUT_VARIABLE
                        ECHO_ERROR_VARIABLE
                        COMMAND_ERROR_IS_FATAL ANY
                    )

                    # Escape quotes to preserve them when they are written to JSON
                    string(CONCAT out "${out1}" "${out2}")
                    string(REPLACE "\"" "\\\"" out "${out}")
                    string(REPLACE ";" "" out "${out}")

                    string(JSON candidate_json SET "${candidate_json}" ${test_key} \"${out}\")
                    string(APPEND image_str "${out}")

                    math(EXPR num_diffs "${num_diffs}+1")
                endif()
            endforeach() # j (test_key)

            # Add candidate_json to this image_json
            string(JSON image_json SET "${image_json}" ${candidate_key} ${candidate_json})
        endforeach() # i (candidate_key)

        # Add image_json to our top-level JSON object
        string(JSON diff_results_json SET "${diff_results_json}" ${image_key} "\"${image_json}\"")

        message("[RATS] Finished ${N} diffs for canonical ${image_key} (${current_canonical}/${num_canonicals} canonicals for test ${TEST_REL_PATH}.)")
        math(EXPR current_canonical "${current_canonical}+1")
        message("\n[RATS] ${num_diffs} unique diffs performed.")
        message("[RATS] ${num_copies} copies performed.")
        message("[RATS] ${num_empties} diffs skipped (self-comparisons).\n")

        math(EXPR actual "${num_diffs} + ${num_copies} + ${num_skips}")
        math(EXPR expected "${N} * ${N}")
        if (NOT actual EQUAL expected)
            message(FATAL_ERROR "${actual} != ${expected}")
        endif()

        file(APPEND ${awk_input_file} "${image_str}")
    endforeach() # image_key

    set(diff_results_file "diff_results.json")
    file(WRITE ${diff_results_file} ${diff_results_json})
    message("[RATS] Wrote diff results to ${diff_results_file}")
endif() # generate_new_canonical

# Run the awk cmd to analyze test results
set(awk_output_file "awk_output.json")
process_test_results("${awk_input_file}" "${awk_output_file}")
message("[RATS] Wrote awk ouput to ${awk_output_file}")

# Read in the output of our awk script.
file(READ ${awk_output_file} awk_output)

file(TO_NATIVE_PATH ${canonicals_root}/${DIFF_JSON} diff_json_file)

# For each canonical image
foreach(image_filename ${CANONICALS})
    # Report the best candidate (index)
    string(JSON candidate_index GET ${awk_output} ${image_filename} "best candidate" "index")
    message("[RATS] ${image_filename}: best candidate is ${candidate_index}")

    if (generate_new_canonical)
        # Copy best candidate's canonical to the RATS_CANONICALS directory. This will be
        # our new canonical, assuming the file is eventually committed/merged.
        set(candidate_dir "${tmp_dir}/${candidate_index}")
        set(mkdir_cmd ${CMAKE_COMMAND} -E make_directory "${full_canonical_path}")
        exec_and_check(COMMAND ${mkdir_cmd} WORKING_DIRECTORY ${candidate_dir})
        set(copy_cmd ${CMAKE_COMMAND} -E copy "${image_filename}" "${full_canonical_path}")
        exec_and_check(COMMAND ${copy_cmd} WORKING_DIRECTORY ${candidate_dir})
        message("[RATS] Copied canonical from ${candidate_dir}/${image_filename}\n")
    endif()

    string(JSON diff_args GET ${awk_output} ${image_filename} "diff args")

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

# cleanup tmp dir, which contains all of the candidate images.
file(REMOVE_RECURSE ${tmp_dir})

# We'll leave the following files in the build directory for this test, since they are
# relatively small and may be useful/interesting for reviewing/debugging.  Should we
# decide they are not needed we could simply create them within the ${tmp_dir} rather
# than at the root.
#   diff_results.json       <-- all idiff results in human-readable JSON format
#   awk_input.json          <-- this same data in awk-friendly format, one line at a time
#   awk_output.json         <-- the analytics from awk in human/cmake-readable JSON format
