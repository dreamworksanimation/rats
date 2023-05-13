# Copyright 2023 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

# Get list of arguments for the idiff cmd for the given EXEC_MODE.
# Default args are defined within this function for each execution mode,
# and are overriden by any matching additional arguments passed.
# The 'out_var' variable will contain the final list of arguments.
function(_get_idiff_args out_var)
    set(options -p -q -a -abs)
    set(oneValueArgs EXEC_MODE -fail -failrelative -failpercent -hardfail -allowfailures -warn -warnrelative -warnpercent -hardwarn -scale)
    set(multiValueArgs "") # currently unused

    # parse and validate arguments
    cmake_parse_arguments(ARG "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})
    if(DEFINED ARG_KEYWORDS_MISSING_VALUES)
        message(FATAL_ERROR "Keywords missing values: ${ARG_KEYWORDS_MISSING_VALUES}")
    endif()
    if(DEFINED ARG_UNPARSED_ARGUMENTS)
        message(FATAL_ERROR "Unrecognized arguments: ${ARG_UNPARSED_ARGUMENTS}")
    endif()
    if(NOT DEFINED ARG_EXEC_MODE)
        message(FATAL_ERROR "You must specify EXEC_MODE.")
    endif()

    # Commented default arguments are not returned by this function
    # unless overridden but are left in place for future use.
    if(${ARG_EXEC_MODE} STREQUAL "scalar")
        set(default_fail            0.004)
        # set(default_failrelative    0)
        set(default_failpercent     0.01)
        set(default_hardfail        0.02)
        # set(default_allowfailures   0)
        set(default_warn            0.004)
        # set(default_warnrelative    0)
        set(default_warnpercent     0.01)
        # set(default_hardwarn        inf)
        # set(default_scale           1)
        # set(default_p               FALSE)
        # set(default_q               FALSE)
        set(default_a               TRUE)
        set(default_abs             TRUE)
    elseif(${ARG_EXEC_MODE} STREQUAL "vector" OR ${ARG_EXEC_MODE} STREQUAL "xpu")
        set(default_fail            0.007)
        # set(default_failrelative    0)
        set(default_failpercent     0.02)
        set(default_hardfail        0.02)
        # set(default_allowfailures   0)
        set(default_warn            0.007)
        # set(default_warnrelative    0)
        set(default_warnpercent     0.02)
        # set(default_hardwarn        inf)
        # set(default_scale           1)
        # set(default_p               FALSE)
        # set(default_q               FALSE)
        set(default_a               TRUE)
        set(default_abs             TRUE)
    else()
        message(FATAL_ERROR "Unrecognized EXEC_MODE: ${ARG_EXEC_MODE}")
    endif()

    set(args "")

    # append any single-value options
    foreach(arg fail;failrelative;failpercent;hardfail;allowfailures;warn;warnrelative;warnpercent;hardwarn;scale)
        set(override ARG_-${arg})
        set(default default_${arg})
        if(DEFINED ${override})
            list(APPEND args -${arg} ${${override}})
        elseif(DEFINED ${default})
            list(APPEND args -${arg} ${${default}})
        endif()
    endforeach()

    # append any flags
    foreach(arg p;q;a;abs)
        set(override ARG_-${arg})
        set(default default_${arg})
        if(${override})
            list(APPEND args -${arg})
        elseif(${default})
            list(APPEND args -${arg})
        endif()
    endforeach()

    set(${out_var} ${args} PARENT_SCOPE)
endfunction()

# Add a new RaTS test.  Each RaTS test will produce a series of CTests, as follows:
# 'canonical' label CTests will:
#       * Render the scene to produce canonical images for each execution mode and
#         copy the outputs= images to the directory specified by the ${RATS_CANONICAL_PATH}
#         cache variable.  The folder structure will be created matching the relative
#         path to the ${CMAKE_CURRENT_SOURCE_DIR} from the ${PROJECT_SOURCE_DIR}.
# 'render' label CTests will:
#       * Render the scene to produce images for each execution mode into the
#         ${CMAKE_CURRENT_BINARY_DIR}.
# 'diff' label CTests will:
#       *  Execute the 'idiff' command on each of the output images comparing it
#          with  the previously rendered canonical image of the same name.
function(add_rats_test test_basename)   # basename of tests including relative folder structure, example: geometry_spheres
    # KEYWORD arguments:
    set(options
            # NO_SCALAR
            # NO_VECTOR
            # NO_XPU
    )

    set(oneValueArgs "") # unused

    set(multiValueArgs
            # optional list of tests that should be ran before this test
            # in multiple job CTest runs (-j N, where N > 0)
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
    set(root_canonical_path ${RATS_CANONICAL_PATH}/${test_rel_path})

    foreach(exec_mode scalar;vector;xpu)
        string(TOUPPER ${exec_mode} exec_mode_upper)
        set(canonical_dir ${root_canonical_path}/${exec_mode})
        set(render_dir ${CMAKE_CURRENT_BINARY_DIR}/${exec_mode})
        file(MAKE_DIRECTORY ${render_dir})

        set(canonical_test_name "rats_${exec_mode}_canonical_${test_basename}")
        set(render_test_name "rats_${exec_mode}_render_${test_basename}")
        set(checkpoint_test_name "rats_${exec_mode}_checkpoint_${test_basename}")

        if(ARG_DEPENDS)
            # compute full name of dependency tests with prefix
            list(TRANSFORM ARG_DEPENDS PREPEND "rats_${exec_mode}_canonical_" OUTPUT_VARIABLE canonical_dependencies)
            list(TRANSFORM ARG_DEPENDS PREPEND "rats_${exec_mode}_render_"    OUTPUT_VARIABLE render_dependencies)
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
        set(moonray_cmd $<TARGET_FILE:moonray>)
        list(APPEND render_cmd -threads 2)

        set(render_cmd ${moonray_cmd})
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

        # Output the list of renderer cmd arguments for each test when
        # cmake is invoked with --log-level=verbose
        # message(VERBOSE "${test_basename} renderer args (${exec_mode_upper}): ${render_cmd}")

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
            ENVIRONMENT RDL2_DSO_PATH=${rdl2_dso_path}
        )

        # Add CTest to diff the result with the canonical via idiff
        foreach(output ${ARG_OUTPUTS})
            cmake_path(GET output STEM stem)
            cmake_path(GET output EXTENSION extension)
            set(diff_test_name "rats_${exec_mode}_diff_${test_basename}_${stem}")
            set(diff_name "${stem}_diff${extension}")

            set(diff_args -o ${diff_name})
            _get_idiff_args(more_args EXEC_MODE ${exec_mode} ${ARG_IDIFF_ARGS_${exec_mode_upper}})
            list(APPEND diff_args ${more_args})

            # Output the list of idiff cmd arguments for each test when
            # cmake is invoked with --log-level=verbose
            message(VERBOSE "${test_basename} idiff args (${exec_mode_upper}): ${diff_args}")

            add_test(NAME ${diff_test_name}
                WORKING_DIRECTORY ${render_dir}
                COMMAND ${IDIFF}
                    -v -a -abs
                    ${diff_args}
                    ${output} ${canonical_dir}/${output}
            )
            set_tests_properties(${diff_test_name} PROPERTIES
                LABELS "diff"
                DEPENDS ${render_test_name}
            )
        endforeach()
    endforeach()
endfunction()

