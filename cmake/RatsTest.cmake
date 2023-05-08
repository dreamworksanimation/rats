# Copyright 2023 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

function(add_rats_test test_basename)
    set(options DENOISE)
    set(oneValueArgs SCENE_DIR)
    set(multiValueArgs EXEC_MODES IDIFF_ARGS INPUTS MOONRAY_ARGS OUTPUTS)
    cmake_parse_arguments(ARG "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})

    set(rdl2_dso_path ${CMAKE_BINARY_DIR}/rdl2dso/)
    set(rats_assets_dir ${PROJECT_SOURCE_DIR}/assets/)

    file(RELATIVE_PATH test_rel_path ${PROJECT_SOURCE_DIR}/tests/ ${CMAKE_CURRENT_SOURCE_DIR})
    set(root_canonical_path ${RATS_CANONICAL_PATH}/${test_rel_path})

    foreach(exec_mode ${ARG_EXEC_MODES})
        set(canonical_dir ${root_canonical_path}/${exec_mode})
        set(render_dir ${CMAKE_CURRENT_BINARY_DIR}/${exec_mode})
        file(MAKE_DIRECTORY ${render_dir})

        set(canonical_test_name "rats_${exec_mode}_canonical_${test_basename}")
        set(canonical_denoise_test_name "rats_${exec_mode}_canonical_denoise_${test_basename}")
        set(render_test_name "rats_${exec_mode}_render_${test_basename}")
        set(render_denoise_test_name "rats_${exec_mode}_render_denoise_${test_basename}")

        # build moonray command. We need the fully qualified path to the moonray executable if
        # we are going to be running it using the ${CMAKE_COMMAND} -P <script.cmake> method
        set(moonray_cmd $<TARGET_FILE:moonray>)
        foreach(rdl_input ${ARG_INPUTS})
            list(APPEND moonray_cmd -in ${ARG_SCENE_DIR}/${rdl_input})
        endforeach()
        list(APPEND moonray_cmd -exec_mode ${exec_mode})
        list(APPEND moonray_cmd -threads ${RATS_NUM_THREADS})
        list(APPEND moonray_cmd -res ${RATS_RENDER_RES})
        list(APPEND moonray_cmd ${ARG_MOONRAY_ARGS})
        # leveraging Lua string literal in [[double brackets]] to avoid escaping problems
        list(APPEND moonray_cmd -rdla_set "rats_assets_dir" "[[${rats_assets_dir}]]")

        # add test to generate canonicals
        add_test(NAME ${canonical_test_name}
            WORKING_DIRECTORY ${render_dir}
            COMMAND ${CMAKE_COMMAND}
                    "-DMOONRAY_CMD=${moonray_cmd}"
                    "-DCANONICAL_PATH=${canonical_dir}"
                    "-DOUTPUTS=${ARG_OUTPUTS}"
                    -P ${PROJECT_SOURCE_DIR}/cmake/RenderCanonicals.cmake
        )
        set_tests_properties(${canonical_test_name} PROPERTIES
            LABELS "canonical"
            ENVIRONMENT RDL2_DSO_PATH=${rdl2_dso_path}
        )
        # add test to denoise canonical?
        # if(ARG_DENOISE)
            # add_test(NAME ${canonical_denoise_test_name}
                # WORKING_DIRECTORY ${CMAKE_BINARY_DIR}
                # COMMAND denoise -mode oidn -in ${canonical_dir}/${image_name} -out ${canonical_dir}/${image_name}
            # )
            # set_tests_properties(${canonical_denoise_test_name} PROPERTIES
                # LABELS "canonical"
                # DEPENDS ${canonical_test_name}
            # )
        # endif()

        # add test to render result
        add_test(NAME ${render_test_name}
            WORKING_DIRECTORY ${render_dir}
            COMMAND ${moonray_cmd}
        )
        set_tests_properties(${render_test_name} PROPERTIES
            LABELS "render"
            ENVIRONMENT RDL2_DSO_PATH=${rdl2_dso_path}
        )
        # add test to denoise rendered result?
        # if(ARG_DENOISE)
            # add_test(NAME ${render_denoise_test_name}
                # WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
                # COMMAND denoise -mode oidn -in ${image_name} -out ${image_name}
            # )
            # set_tests_properties(${render_denoise_test_name} PROPERTIES
                # LABELS "render"
                # DEPENDS ${render_test_name}
            # )
        # endif()

        # add test to diff the result with the canonical via oiiotool
        foreach(output ${ARG_OUTPUTS})
            set(diff_test_name "rats_${exec_mode}_diff_${test_basename}_${output}")
            cmake_path(GET output STEM stem)
            cmake_path(GET output EXTENSION extension)
            set(diff_name "${stem}_diff${extension}")

            add_test(NAME ${diff_test_name}
                WORKING_DIRECTORY ${render_dir}
                COMMAND ${IDIFF}
                    -o ${diff_name}
                    ${ARG_IDIFF_ARGS}
                    -abs
                    ${output} ${canonical_dir}/${output}
            )
            set_tests_properties(${diff_test_name} PROPERTIES
                LABELS "diff"
                DEPENDS ${render_test_name}
            )
        endforeach()
    endforeach()
endfunction()

