# Copyright 2025 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

# =====================================================================================
# This script is run during execution of the rats tests via
#     ${CMAKE_COMMAND} -P <thisscript>.cmake -DEXAMPLE_DEF1=... -DEXAMPLE_DEF2=...
#
# It is responsible for diff'ing a pair of [canonical,result] images
# -------------------------------------------------------------------------------------

# Validate script inputs. These are required to be defined:
foreach(required_def
    DIFF_IMAGE_FILENAME             # name of diff image to output, e.g. scene.diff.exr
    EXEC_MODE                       # (scalar|vector|xpu)
    IDIFF_TOOL                      # full path to the openimageio 'idiff' cmd
    IMAGE_FILENAME                  # name of image to compare, e.g. scene.exr
    TEST_REL_PATH)                  # relative test path, e.g. moonray/map/checkerboard
    if(NOT DEFINED ${required_def})
        message(FATAL_ERROR "[RATS] ${required_def} is undefined")
    endif()
endforeach()

# Make sure RATS_CANONICAL_DIR is set and valid
if(NOT DEFINED ENV{RATS_CANONICAL_DIR})
    message(FATAL_ERROR "[RATS] RATS_CANONICAL_DIR is undefined")
endif()
file(TO_NATIVE_PATH "$ENV{RATS_CANONICAL_DIR}" canonicals_root)
cmake_path(NORMAL_PATH canonicals_root)
if(NOT EXISTS ${canonicals_root})
    message(FATAL_ERROR "[RATS] RATS_CANONICAL_DIR ${canonicals_root} does not exist")
endif()

# Establish fully qualified path to the canonicals for this test
file(TO_NATIVE_PATH "${canonicals_root}/${TEST_REL_PATH}/${EXEC_MODE}/" test_canonical_path)
cmake_path(NORMAL_PATH test_canonical_path)
file(TO_NATIVE_PATH "${test_canonical_path}/${IMAGE_FILENAME}" canonical_image)
cmake_path(NORMAL_PATH canonical_image)
if(NOT EXISTS ${canonical_image})
    message(FATAL_ERROR "[RATS] canonical not found: ${canonical_image}")
endif()

if(NOT EXISTS ${IMAGE_FILENAME})
    message(FATAL_ERROR "[RATS] test image not found: ${IMAGE_FILENAME}")
endif()

set(diff_args "-a;-v;-abs") # we always want to include these flags in our idiff args

# Attempt to read diff args from the diff.json, which is assumed to be stored along with the canonicals.
file(TO_NATIVE_PATH "${canonicals_root}/${TEST_REL_PATH}/diff.json" diff_json_file)
cmake_path(NORMAL_PATH diff_json_file)
if(EXISTS "${diff_json_file}")
    file(READ ${diff_json_file} all_json)

    # Find the JSON object associated with this image/exec_mode
    string(JSON json_object GET "${all_json}" "${IMAGE_FILENAME}" "${EXEC_MODE}")

    string(JSON num_members LENGTH "${json_object}")
    math(EXPR member_range "${num_members}-1")
    foreach(index RANGE ${member_range})
        string(JSON member MEMBER ${json_object} ${index})
        string(JSON value GET ${json_object} ${member})
        if(${member} STREQUAL "flags")
            # special handling for the "flags" section
            string(JSON num_flags LENGTH ${json_object} ${member})
            math(EXPR flags_count "${num_flags}-1")
            foreach(flag_index RANGE ${flags_count})
                string(JSON flag GET ${json_object} ${member} ${flag_index})
                list(APPEND diff_args ${flag})
            endforeach()
        else()
            # otherwise the 'member' is the name of the option, and the 'value' is the value for that option.
            list(APPEND diff_args ${member} ${value})
        endif()
    endforeach()
endif()

execute_process(
    COMMAND ${IDIFF_TOOL} ${diff_args} -o ${DIFF_IMAGE_FILENAME} ${canonical_image} ${IMAGE_FILENAME}
    COMMAND_ECHO STDOUT
    RESULT_VARIABLE idiff_return_code
)

if(idiff_return_code)
    # report diff cmd args
    message("")
    string(JOIN " " idiff_args ${diff_args})
    message("[RATS] ${idiff_args}")

    # report images
    file(TO_NATIVE_PATH "${CMAKE_BINARY_DIR}/${IMAGE_FILENAME}" test_image_full)
    cmake_path(NORMAL_PATH test_image_full)
    file(TO_NATIVE_PATH "${CMAKE_BINARY_DIR}/${DIFF_IMAGE_FILENAME}" diff_image_full)
    cmake_path(NORMAL_PATH diff_image_full)
    message("[RATS]  canonical | ${canonical_image}")
    message("[RATS] test image | ${test_image_full}")
    message("[RATS] diff image | ${diff_image_full}\n")
    message("[RATS] iv ${canonical_image} ${test_image_full} ${diff_image_full}\n")
endif()

# idiff returns 0 on pass, 1 on warning and >=2 on error
if(idiff_return_code GREATER 1)
    message(FATAL_ERROR "[RATS] idiff exit code: ${idiff_return_code}")
endif()

