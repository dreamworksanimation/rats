# Copyright 2023 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0


# Adds a new RaTS test.
# Each RaTS test will produce a series of CTests for each execution mode, as follows:
# 'canonical' label CTests will:
#       * Render the scene to produce canonical images for each execution mode and
#         copy the outputs= images to the directory specified by the ${RATS_CANONICAL_DIR}
#         cache variable.  The folder structure will be created matching the relative
#         path to the ${CMAKE_CURRENT_SOURCE_DIR} from the ${PROJECT_SOURCE_DIR}.
# 'render' label CTests will:
#       * Render the scene to produce images for each execution mode into the
#         ${CMAKE_CURRENT_BINARY_DIR}.
# 'diff' label CTests will:
#       * Execute the 'idiff' command on each of the output images comparing it
#         with  the previously rendered canonical image of the same name.
#       * Compare the headers of .exr output images with the previously rendered
#         canonical image of the same name, ignoring timestamps
function(add_rats_test test_basename)   # basename of tests including relative folder structure, example: geometry_spheres
    # KEYWORD arguments:
    set(options
            # adds a separate CTest with the 'diff' label to compare the canonical
            # and result image's exr headers
            DIFF_HEADERS

            # disables this test
            DISABLED

            # optional execution modes to skip for this test. For example, pathguiding is
            # currently only supported in scalar mode, so tests using it may want to pass
            # NO_VECTOR NO_XPU.
            NO_SCALAR
            NO_VECTOR
            NO_XPU
    )

    set(oneValueArgs "") # unused

    set(multiValueArgs
            # optional list of tests that should be ran before this test
            # in multiple job CTest runs (-j N, where N > 0). When specifying
            DEPENDS

            # optional list of idiff args to set/override
            # example: IDIFF_ARGS_VECTOR -failpercent 0.025 -hardfail 0.035
            IDIFF_ARGS_SCALAR
            IDIFF_ARGS_VECTOR
            IDIFF_ARGS_XPU

            # list of input files the test requires
            # example: INPUTS scene.rdla scene.rdlb
            INPUTS

            # list of output files the test produces.
            # if empty, no canonical/diff CTests are created for this test
            # example: OUTPUTS scene.exr aovs.exr more_aovs.exr
            OUTPUTS

            # optional list of renderer args to set/override
            # example: RENDER_ARGS_XPU -scene_var \"pixel_samples\" \"1\" -texture_cache_size 8192
            RENDER_ARGS_SCALAR
            RENDER_ARGS_VECTOR
            RENDER_ARGS_XPU
    )

    # parse and validate arguments
    cmake_parse_arguments(ARG "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})
    if(DEFINED ARG_KEYWORDS_MISSING_VALUES)
        message(FATAL_ERROR "Keywords missing values: ${ARG_KEYWORDS_MISSING_VALUES}")
    endif()
    if(DEFINED ARG_UNPARSED_ARGUMENTS)
        message(FATAL_ERROR "Unrecognized arguments: ${ARG_UNPARSED_ARGUMENTS}")
    endif()
    if(NOT DEFINED ARG_INPUTS)
        message(FATAL_ERROR "You must specify INPUTS")
    endif()

    set(rdl2_dso_path ${CMAKE_BINARY_DIR}/rdl2dso/)
    set(rats_assets_dir ${PROJECT_SOURCE_DIR}/assets/)

    file(RELATIVE_PATH test_rel_path ${PROJECT_SOURCE_DIR}/tests/ ${CMAKE_CURRENT_SOURCE_DIR})
    set(root_canonical_path ${RATS_CANONICAL_DIR}/${test_rel_path})

    set(exec_modes "")
    if(NOT ARG_NO_SCALAR)
        list(APPEND exec_modes scalar)
    endif()
    if(NOT ARG_NO_VECTOR)
        list(APPEND exec_modes vector)
    endif()
    if(NOT ARG_NO_XPU)
        list(APPEND exec_modes xpu)
    endif()

    foreach(exec_mode ${exec_modes})
        set(canonical_dir ${root_canonical_path}/${exec_mode})
        set(render_dir ${CMAKE_CURRENT_BINARY_DIR}/${exec_mode})
        file(MAKE_DIRECTORY ${render_dir})

        string(TOUPPER ${exec_mode} exec_mode_upper)
        string(SUBSTRING ${exec_mode} 0 3 exec_mode_short)
        set(canonical_test_name "rats_${exec_mode_short}_canonical_${test_basename}")
        set(render_test_name "rats_${exec_mode_short}_render_${test_basename}")

        if(ARG_DEPENDS)
            # compute full name of dependency tests with prefix
            list(TRANSFORM ARG_DEPENDS PREPEND "rats_${exec_mode_short}_canonical_" OUTPUT_VARIABLE canonical_dependencies)
            list(TRANSFORM ARG_DEPENDS PREPEND "rats_${exec_mode_short}_render_"    OUTPUT_VARIABLE render_dependencies)
            # join them into one big list and verify they exist
            string(JOIN % dependencies ${canonical_dependencies})
            string(JOIN % dependencies ${render_dependencies})
            foreach(test ${dependencies})
                if(NOT TEST ${test})
                    message(FATAL_ERROR "No test named ${test} exists to add as a dependency")
                endif()
            endforeach()
        endif()

        # Build moonray command. We need the fully qualified path to the moonray executable if
        # we are going to be running it using the ${CMAKE_COMMAND} -P <script.cmake> method.
        # NOTE: $<TARGET_FILE:moonray> isn't expanded until _build_ time.
        set(render_cmd $<TARGET_FILE:moonray>)

        if(NOT "$CACHE{RATS_RENDER_THREADS}" STREQUAL "")
            list(APPEND render_cmd -threads $CACHE{RATS_RENDER_THREADS})
        endif()

        foreach(rdl_input ${ARG_INPUTS})
            list(APPEND render_cmd -in ${CMAKE_CURRENT_SOURCE_DIR}/${rdl_input})
        endforeach()
        list(APPEND render_cmd -exec_mode ${exec_mode})
        list(APPEND render_cmd -rdla_set "rats_assets_dir" "[[${rats_assets_dir}]]")

        if(${exec_mode} STREQUAL scalar)
            list(APPEND render_cmd ${ARG_RENDER_ARGS_SCALAR})
        elseif (${exec_mode} STREQUAL vector)
            list(APPEND render_cmd ${ARG_RENDER_ARGS_VECTOR})
        elseif (${exec_mode} STREQUAL xpu)
            list(APPEND render_cmd ${ARG_RENDER_ARGS_XPU})
        endif()

        # Add CTest to generate canonicals
        add_test(NAME ${canonical_test_name}
            WORKING_DIRECTORY ${render_dir}
            COMMAND ${CMAKE_COMMAND}
                    "-DRENDER_CMD=${render_cmd}"
                    "-DCANONICAL_PATH=${canonical_dir}"
                    "-DOUTPUTS=${ARG_OUTPUTS}"
                    -P ${PROJECT_SOURCE_DIR}/cmake/RenderCanonicals.cmake
        )
        set_tests_properties(${canonical_test_name} PROPERTIES
            LABELS "canonical"
            DEPENDS "${canonical_dependencies}"
            DISABLED ${ARG_DISABLED}
            ENVIRONMENT RDL2_DSO_PATH=${rdl2_dso_path}
        )

        # Add CTest to render result
        add_test(NAME ${render_test_name}
            WORKING_DIRECTORY ${render_dir}
            COMMAND ${render_cmd}
        )
        set_tests_properties(${render_test_name} PROPERTIES
            LABELS "render"
            DEPENDS "${render_dependencies}"
            DISABLED ${ARG_DISABLED}
            ENVIRONMENT RDL2_DSO_PATH=${rdl2_dso_path}
        )

        # Add CTest to diff against the canonical images
        foreach(output ${ARG_OUTPUTS})
            cmake_path(GET output STEM stem)
            cmake_path(GET output EXTENSION extension)

            # diff exr header?
            if(ARG_DIFF_HEADERS)
                set(header_test_name "rats_${exec_mode_short}_header_${test_basename}_${stem}${extension}")

                add_test(NAME ${header_test_name}
                    WORKING_DIRECTORY ${render_dir}
                    COMMAND ${CMAKE_COMMAND}
                            "-DOIIOTOOL=${OIIOTOOL}"
                            "-DCANONICAL=${canonical_dir}/${output}"
                            "-DRESULT=${output}"
                            -P ${PROJECT_SOURCE_DIR}/cmake/CompareImageHeaders.cmake
                )
                set_tests_properties(${header_test_name} PROPERTIES
                    LABELS "diff"
                    DEPENDS "${render_test_name}"
                    DISABLED ${ARG_DISABLED}
                )
            endif()

            set(diff_test_name "rats_${exec_mode_short}_diff_${test_basename}_${stem}${extension}")

            add_test(NAME ${diff_test_name}
                WORKING_DIRECTORY ${render_dir}
                COMMAND ${CMAKE_COMMAND}
                        "-DEXEC_MODE=${exec_mode}"
                        "-DCANONICAL=${canonical_dir}/${output}"
                        "-DRESULT=${output}"
                        "-DDIFF_IMAGE=${diff_image_name}"
                        "-DIDIFF=${IDIFF}"
                        "-DIDIFF_ARGS=${ARG_IDIFF_ARGS_${exec_mode_upper}}"
                        -P ${PROJECT_SOURCE_DIR}/cmake/CompareImages.cmake
            )
            set_tests_properties(${diff_test_name} PROPERTIES
                LABELS "diff"
                DEPENDS ${render_test_name}
                DISABLED ${ARG_DISABLED}
            )
        endforeach()
    endforeach()
endfunction()

