# Copyright 2023 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

function(add_rats_test test_basename)
    set(options DENOISE)    # unused
    set(oneValueArgs WORKING_DIRECTORY)
    set(multiValueArgs EXEC_MODES INPUTS MOONRAY_ARGS IDIFF_ARGS)
    cmake_parse_arguments(ARG "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})

    set(rdl2_dso_path ${CMAKE_BINARY_DIR}/rdl2dso/)
    set(rats_assets_dir ${PROJECT_SOURCE_DIR}/assets/)

    foreach(exec_mode ${ARG_EXEC_MODES})

        set(canonical_test_name "rats_${exec_mode}_canonical_${test_basename}")
        set(canonical_denoise_test_name "rats_${exec_mode}_canonical_denoise_${test_basename}")
        set(render_test_name "rats_${exec_mode}_render_${test_basename}")
        set(render_denoise_test_name "rats_${exec_mode}_render_denoise_${test_basename}")
        set(diff_test_name "rats_${exec_mode}_diff_${test_basename}")

        set(image_name "${test_basename}_${exec_mode}.exr")
        set(diff_name "${test_basename}_${exec_mode}_diff.exr")

        # create arg list
        set(arg_list "")

        foreach(rdl_input ${ARG_INPUTS})
            list(APPEND arg_list -in ${rdl_input})
        endforeach()

        list(APPEND arg_list -exec_mode ${exec_mode})
        list(APPEND arg_list -threads ${RATS_NUM_THREADS})
        list(APPEND arg_list -res ${RATS_RENDER_RES})

        list(APPEND arg_list ${ARG_MOONRAY_ARGS})

        # add test to generate canonicals
        set(canonical_arg_list ${arg_list})
        list(APPEND canonical_arg_list -out ${RATS_CANONICAL_PATH}/${image_name})
        add_test(NAME ${canonical_test_name}
            WORKING_DIRECTORY ${ARG_WORKING_DIRECTORY}
            COMMAND moonray -rdla_set "rats_assets_dir" "\"${rats_assets_dir}\"" ${canonical_arg_list}
        )
        set_tests_properties(${canonical_test_name} PROPERTIES
            LABELS "canonicals"
            ENVIRONMENT RDL2_DSO_PATH=${rdl2_dso_path}
        )
        # add test to denoise canonical?
        if(ARG_DENOISE)
            add_test(NAME ${canonical_denoise_test_name}
                WORKING_DIRECTORY ${CMAKE_BINARY_DIR}
                COMMAND denoise -mode oidn -in ${RATS_CANONICAL_PATH}/${image_name} -out ${RATS_CANONICAL_PATH}/${image_name}
            )
            set_tests_properties(${canonical_denoise_test_name} PROPERTIES
                LABELS "canonical"
                DEPENDS ${canonical_test_name}
            )
        endif()

        # add test to render result
        set(render_arg_list ${arg_list})
        list(APPEND render_arg_list -out ${CMAKE_CURRENT_BINARY_DIR}/${image_name})
        add_test(NAME ${render_test_name}
            WORKING_DIRECTORY ${ARG_WORKING_DIRECTORY}
            COMMAND moonray -rdla_set "rats_assets_dir" "\"${rats_assets_dir}\"" ${render_arg_list}
        )
        set_tests_properties(${render_test_name} PROPERTIES
            LABELS "rats;render"
            ENVIRONMENT RDL2_DSO_PATH=${rdl2_dso_path}
        )
        # add test to denoise rendered result?
        if(ARG_DENOISE)
            add_test(NAME ${render_denoise_test_name}
                WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
                COMMAND denoise -mode oidn -in ${image_name} -out ${image_name}
            )
            set_tests_properties(${render_denoise_test_name} PROPERTIES
                LABELS "rats;render"
                DEPENDS ${render_test_name}
            )
        endif()

        # add test to diff the result with the canonical via oiiotool
        add_test(NAME ${diff_test_name}
            WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
            COMMAND ${IDIFF}
                -o ${diff_name}
                ${ARG_IDIFF_ARGS}
                -abs
                ${image_name} ${RATS_CANONICAL_PATH}/${image_name}
        )
        set_tests_properties(${diff_test_name} PROPERTIES
            LABELS "rats;diff"
            DEPENDS ${render_test_name}
        )
    endforeach()
endfunction()

