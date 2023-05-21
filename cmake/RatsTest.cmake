# Copyright 2023 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0


# Add a new RaTS test.
# ---------------------
#
# Each call to this function will produce a series of labeled CTests for each of MoonRay's execution modes.
# A typical RaTS test will comprise of 9 or more individual CTests, see below.
#
# ---------------------
#
# TEST NAMES:
# Each test will be named according to the following convention:
#   rats_<exec_mode>_<task>_<test_basename>[_output]
#
#   * the <exec_mode> token will be one of sca|vec|xpu
#   * the <task> token will be canonical|render|diff|header
#   * the [_output] token appears on diff/header tasks and will be the name of the image, eg. _scene.exr
#
# ---------------------
#
# LABELS:
# See https://cmake.org/cmake/help/latest/prop_test/LABELS.html
# Each test will have its LABELS property set according to the CTest's task, with the following convention:
# 'canonical' labeled CTests will:
#       * Render the scene to produce canonical images and copy each output image to the directory
#         specified by the ${RATS_CANONICAL_DIR} cache variable.  The canonicals folder structure
#         will be created matching the relative path to the ${CMAKE_CURRENT_SOURCE_DIR} from the
#         ${PROJECT_SOURCE_DIR} and will include the execution mode.
#
# 'render' labeled CTests will:
#       * Render the scene to produce images into the build directory under the <execution_mode>/ dir.
#
# 'diff' labeled CTests will:
#       * Execute the 'idiff' command an output image comparing it with previously rendered canonical image of the same name.
#       * Or... compare the header of an output image with previously rendered canonical image of the same name.
#
# ---------------------
function(add_rats_test test_basename)
    # basename:                 basename of tests. By convention includes relative folder structure, example: moonray_geometry_spheres

    # The following KEYWORD arguments are supported:
    set(options
            DIFF_HEADERS        # (optional) adds an extra CTest with the 'diff' label to compare the canonical
                                # and result image headers.

            DISABLED            # (optional) disables this test, for whatever reason.

            NO_SCALAR           # | (optional) execution modes to skip for this test. For example, path guiding is
            NO_VECTOR           # | currently only supported in scalar mode, so tests using path guiding may want
            NO_XPU              # | to pass: NO_VECTOR NO_XPU.
    )

    set(oneValueArgs "")        # currently unused

    set(multiValueArgs
            DEPENDS             # (optional) list of tests that should be ran before this test (for canonical and
                                # render tasks) when running ctest with multiple jobs (eg. -j N). For example,
                                # for a test that uses checkpoint/resume rendering the resume test should run _after_
                                # the checkpoint test, and should therefore specify the checkpoint test's basename
                                # in its DEPENDS list.
                                # (Note that CTests are alway rans in the order they are added when -j is omitted,
                                # but specifying an explicit dependency here allows such tests to run in the correct
                                # order when multiple jobs are used via the -J option to the ctest command).

            IDIFF_ARGS_SCALAR   # | (optional) list of idiff args to set/override for a particular execution mode.
            IDIFF_ARGS_VECTOR   # | example: IDIFF_ARGS_VECTOR -failpercent 0.025 -hardfail 0.035
            IDIFF_ARGS_XPU

            INPUTS              # (required) ordered list of input files the test requires.
                                # example: INPUTS scene.rdla scene.rdlb

            OUTPUTS             # (optional) list of output files the test produces (aka. results/canonicals).
                                # if empty, no canonical/diff/header CTests are created for this test.
                                # example: OUTPUTS scene.exr aovs.exr more_aovs.exr

            RENDER_ARGS_SCALAR  # | (optional) list of renderer args to set/override.
            RENDER_ARGS_VECTOR  # | example: RENDER_ARGS_XPU -scene_var \"pixel_samples\" \"1\" -texture_cache_size 8192
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

    # configure some paths
    set(rdl2_dso_path ${CMAKE_BINARY_DIR}/rdl2dso/)
    set(rats_assets_dir ${PROJECT_SOURCE_DIR}/assets/)
    file(RELATIVE_PATH test_rel_path ${PROJECT_SOURCE_DIR}/tests/ ${CMAKE_CURRENT_SOURCE_DIR})
    set(root_canonical_path ${RATS_CANONICAL_DIR}/${test_rel_path})

    # determine which execution modes are needed
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

    # add CTests
    foreach(exec_mode ${exec_modes})
        set(canonical_dir ${root_canonical_path}/${exec_mode})
        set(render_dir ${CMAKE_CURRENT_BINARY_DIR}/${exec_mode})
        string(TOUPPER ${exec_mode} exec_mode_upper)
        string(SUBSTRING ${exec_mode} 0 3 exec_mode_short)
        set(canonical_test_name "rats_${exec_mode_short}_canonical_${test_basename}")
        set(render_test_name "rats_${exec_mode_short}_render_${test_basename}")
        file(MAKE_DIRECTORY ${render_dir})

        if(ARG_DEPENDS)
            # compute full name of dependency tests with prefix
            list(TRANSFORM ARG_DEPENDS PREPEND "rats_${exec_mode_short}_canonical_" OUTPUT_VARIABLE canonical_dependencies)
            list(TRANSFORM ARG_DEPENDS PREPEND "rats_${exec_mode_short}_render_"    OUTPUT_VARIABLE render_dependencies)
            # join them into one big list and verify that each CTest exists
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

            # diff image header?
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

            # diff output images
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
        endforeach() # output
    endforeach() # exec mode
endfunction()

