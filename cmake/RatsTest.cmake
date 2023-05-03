# Copyright 2023 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

function(add_rats_test test_basename)
    set(options FOO)    # unused
    set(oneValueArgs THREADS WORKING_DIRECTORY)
    set(multiValueArgs EXEC_MODES INPUTS LABELS)
    cmake_parse_arguments(ARG "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})

    set(rdl2_dso_path ${CMAKE_BINARY_DIR}/rdl2dso/)

    foreach(exec_mode ${ARG_EXEC_MODES})
        set(test_name ${test_basename}_${exec_mode})

        set(image_name "${test_name}.exr")

        # create arg list
        set(arg_list "")

        foreach(rdl_input ${ARG_INPUTS})
            list(APPEND arg_list -in ${rdl_input})
        endforeach()

        list(APPEND arg_list -exec_mode ${exec_mode})
        list(APPEND arg_list -threads ${RATS_NUM_THREADS})
        list(APPEND arg_list -res ${RATS_RENDER_RES})

        # add test to generate canonicals
        set(canonical_arg_list ${arg_list})
        list(APPEND canonical_arg_list -out ${RATS_CANONICAL_PATH}/${image_name})
        add_test(NAME ${test_name}_canonicals
            WORKING_DIRECTORY ${ARG_WORKING_DIRECTORY}
            COMMAND moonray ${canonical_arg_list}
        )
        set_tests_properties(${test_name}_canonicals PROPERTIES
            LABELS "canonicals"
            ENVIRONMENT RDL2_DSO_PATH=${rdl2_dso_path}
        )

        # add test to render results
        set(render_arg_list ${arg_list})
        list(APPEND render_arg_list -out ${CMAKE_CURRENT_BINARY_DIR}/${image_name})
        add_test(NAME ${test_name}_render
            WORKING_DIRECTORY ${ARG_WORKING_DIRECTORY}
            COMMAND moonray ${render_arg_list}
        )
        set_tests_properties(${test_name}_render PROPERTIES
            FIXTURES_SETUP ${test_name}_render
            LABELS "rats"
            ENVIRONMENT RDL2_DSO_PATH=${rdl2_dso_path}
        )

        # add test to diff the result with the canonical via oiiotool
        add_test(NAME ${test_name}_diff
            WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
            COMMAND oiiotool -i ${image_name} --diff -i ${RATS_CANONICAL_PATH}/${image_name}
            COMMAND_EXPAND_LISTS
        )
        set_tests_properties(${test_name}_diff PROPERTIES
            LABELS "rats"
            FIXTURES_REQUIRED ${test_name}_render
        )
    endforeach()
endfunction()

