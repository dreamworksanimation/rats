# Copyright 2025 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

set(supported_renderers moonray hd_render)

# Add a new RaTS test.
# ---------------------
#
# Each call to this function will produce a series of labeled CTests for each of MoonRay's execution modes.
# A typical RaTS test will comprise 9 or more individual CTests, which can later be run in stages; see below.
#
# ---------------------
#
# TEST NAMES:
# Each test will be named according to the following convention:
#   rats_<exec_mode>_<stage>_<basename>[_output]
#
#   * the <exec_mode> token will be one of sca|vec|xpu
#   * the <stage> token will be canonical|render|diff|header
#   * the [_output] token appears on diff & header stages and will be the name of the image, eg. _scene.exr
#
# ---------------------
#
# LABELS:
# See https://cmake.org/cmake/help/latest/prop_test/LABELS.html
# Each test will have its LABELS property set according to the CTest's stage, with the following convention:
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
function(add_rats_test)

    # The following KEYWORD arguments are supported:
    set(options
            DIFF_HEADERS        # Adds an extra CTest with the 'diff' label to compare the canonical
                                # and result image headers.

            DISABLED            # Disables this test, for whatever reason.

            NO_SCALAR           # | Execution modes to skip for this test. For example, path guiding is
            NO_VECTOR           # | currently only supported in scalar mode, so tests using path guiding may want
            NO_XPU              # | to pass: NO_VECTOR NO_XPU.
            SKIP_IMAGE_DIFF     # Do not generate canonical/diff/header stages for this test.
    )

    set(oneValueArgs
            BASENAME            # Basename of tests. By convention includes relative folder structure, example: moonray_geometry_spheres
            OUTPUT              # Name of output image file, will be added to render args as -out <OUTPUT>
            RENDERER            # moonray|hd_render (defaults to moonray)
    )

    set(multiValueArgs
            CANONICALS          # List of output files the test produces (aka. results/canonicals).
                                # if empty, no canonical/diff/header stages are created for this test.
                                # example: CANONICALS scene.exr aovs.exr more_aovs.exr

            DEPENDS             # List of tests that should be run before this test (for canonical and
                                # render stages) when running ctest with multiple jobs (eg. -j N). For example,
                                # for a test that uses checkpoint/resume rendering the resume test should run _after_
                                # the checkpoint test, and should therefore specify the checkpoint test's basename
                                # in its DEPENDS list.
                                # (Note that CTests are always run in the order they are added when -j is omitted,
                                # but specifying an explicit dependency here allows such tests to run in the correct
                                # order when multiple jobs are used via the -J option to the ctest command).

            INPUTS              # (required) Ordered list of input files the test requires.
                                # example: INPUTS scene.rdla scene.rdlb

            DELTAS              # Ordered list of optional delta files for the test.
                                # example: DELTAS deltas.rdla

            ENVIRONMENT         # List of definitions to be available as env vars during test runtime, for example:
                                # ENVIRONMENT TEST_ASSETS_DIR=/some/path ANOTHER_VAR="another value"

            RENDER_ARGS         # List of renderer args to set/override.
            RENDER_ARGS_SCALAR  # | List of renderer args to set/override per execution mode.
            RENDER_ARGS_VECTOR  # | Example: RENDER_ARGS_XPU -scene_var pixel_samples 1 -texture_cache_size 8192
            RENDER_ARGS_XPU     # |
    )

    # parse and validate arguments
    cmake_parse_arguments(ARG "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})
    if(DEFINED ARG_KEYWORDS_MISSING_VALUES)
        message(FATAL_ERROR "Keywords missing values: ${ARG_KEYWORDS_MISSING_VALUES}")
    endif()
    if(DEFINED ARG_UNPARSED_ARGUMENTS)
        message(FATAL_ERROR "Unrecognized arguments: ${ARG_UNPARSED_ARGUMENTS}")
    endif()
    if(NOT DEFINED ARG_BASENAME)
        message(FATAL_ERROR "You must specify a BASENAME for the test")
    endif()
    if(NOT DEFINED ARG_INPUTS)
        message(FATAL_ERROR "You must specify INPUTS")
    endif()

    if(NOT DEFINED ARG_RENDERER)
        set(renderer "moonray") # default renderer
    else()
        set(renderer ${ARG_RENDERER})
    endif()
    if(NOT ${renderer} IN_LIST supported_renderers)
        message(FATAL_ERROR "Unsupported renderer: ${renderer}")
    endif()

    # configure some paths
    file(RELATIVE_PATH test_rel_path ${PROJECT_SOURCE_DIR}/tests/ ${CMAKE_CURRENT_SOURCE_DIR})

    # determine which execution modes are needed
    if(${renderer} STREQUAL "moonray")
        if(NOT ARG_NO_SCALAR)
            list(APPEND exec_modes scalar)
        endif()
        if(NOT ARG_NO_VECTOR)
            list(APPEND exec_modes vector)
        endif()
        if(NOT ARG_NO_XPU)
            list(APPEND exec_modes xpu)
        endif()
    else()
        # hd_render does not yet allow for specifying exec mode
        list(APPEND exec_modes default)
    endif()

    # construct list of env vars to be made available at test runtime
    set(assets_dir "${CMAKE_CURRENT_FUNCTION_LIST_DIR}/../assets")
    cmake_path(NATIVE_PATH assets_dir NORMALIZE assets_dir)
    set(runtime_env_vars "RATS_ASSETS_DIR=${assets_dir}")
    list(APPEND runtime_env_vars "${ARG_ENVIRONMENT}")

    # add CTests
    foreach(exec_mode ${exec_modes})
        # Build render command
        if(${renderer} STREQUAL "moonray")
            set(render_cmd moonray -info)
        elseif(${renderer} STREQUAL "hd_render")
            set(render_cmd hd_render)
        endif()

        set(render_dir ${CMAKE_CURRENT_BINARY_DIR}/${exec_mode})
        string(TOUPPER ${exec_mode} exec_mode_upper)
        string(SUBSTRING ${exec_mode} 0 3 exec_mode_short)
        set(canonical_test_name "rats_${exec_mode_short}_canonical_${ARG_BASENAME}")
        set(super_test_name "rats_${exec_mode_short}_super_${ARG_BASENAME}")
        set(render_test_name "rats_${exec_mode_short}_render_${ARG_BASENAME}")
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

        foreach(rdl_input ${ARG_INPUTS})
            list(APPEND render_cmd -in ${CMAKE_CURRENT_SOURCE_DIR}/${rdl_input})
        endforeach()
        foreach(rdl_delta ${ARG_DELTAS})
            list(APPEND render_cmd -deltas ${CMAKE_CURRENT_SOURCE_DIR}/${rdl_delta})
        endforeach()
        if(${renderer} STREQUAL "moonray")
            list(APPEND render_cmd -exec_mode ${exec_mode})
        endif()
        if(DEFINED ARG_OUTPUT)
            list(APPEND render_cmd -out ${ARG_OUTPUT})
        endif()

        list(APPEND render_cmd ${ARG_RENDER_ARGS})
        if(${exec_mode} STREQUAL scalar)
            list(APPEND render_cmd ${ARG_RENDER_ARGS_SCALAR})
        elseif (${exec_mode} STREQUAL vector)
            list(APPEND render_cmd ${ARG_RENDER_ARGS_VECTOR})
        elseif (${exec_mode} STREQUAL xpu)
            list(APPEND render_cmd ${ARG_RENDER_ARGS_XPU})
        endif()

        if (NOT ${exec_mode} STREQUAL "xpu")
            # Add CTest to generate super canonicals
            add_test(NAME ${super_test_name}
                WORKING_DIRECTORY ${render_dir}
                COMMAND ${CMAKE_COMMAND}
                        "-DRENDER_CMD=${render_cmd}"
                        "-DTEST_REL_PATH=${test_rel_path}/${exec_mode}"
                        "-DCANONICALS=${ARG_CANONICALS}"
                        "-DEXEC_MODE=${exec_mode}"
                        "-DIDIFF_TOOL=${IDIFF}"
                        "-DDIFF_JSON=${CMAKE_CURRENT_SOURCE_DIR}/diff.json"
                        "-DDIFF_DEFAULTS_JSON=${CMAKE_CURRENT_FUNCTION_LIST_DIR}/diff_defaults.json"
                        -P ${CMAKE_CURRENT_FUNCTION_LIST_DIR}/MakeCanonicals.cmake
            )
            set_tests_properties(${super_test_name} PROPERTIES
                LABELS "super"
                DEPENDS "${canonical_dependencies}"
                DISABLED ${ARG_DISABLED}
                ENVIRONMENT "${runtime_env_vars}"
            )
        endif()

        # Add CTest to generate canonicals
        add_test(NAME ${canonical_test_name}
            WORKING_DIRECTORY ${render_dir}
            COMMAND ${CMAKE_COMMAND}
                    "-DRENDER_CMD=${render_cmd}"
                    "-DTEST_REL_PATH=${test_rel_path}/${exec_mode}"
                    "-DCANONICALS=${ARG_CANONICALS}"
                    -P ${CMAKE_CURRENT_FUNCTION_LIST_DIR}/RenderCanonicals.cmake
        )
        set_tests_properties(${canonical_test_name} PROPERTIES
            LABELS "canonical"
            DEPENDS "${canonical_dependencies}"
            DISABLED ${ARG_DISABLED}
            ENVIRONMENT "${runtime_env_vars}"
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
            ENVIRONMENT "${runtime_env_vars}"
        )

        # Add CTest to diff against the canonical images
        if(NOT ARG_SKIP_IMAGE_DIFF)
            foreach(canonical ${ARG_CANONICALS})
                cmake_path(GET canonical STEM stem)
                cmake_path(GET canonical EXTENSION extension)

                set(canonical_exec_mode ${exec_mode})
                if (${exec_mode} STREQUAL "xpu")
                    # xpu and vector modes share the vector canonical
                    set(canonical_exec_mode "vector")
                endif()

                # diff image header?
                if(ARG_DIFF_HEADERS)
                    set(header_test_name "rats_${exec_mode_short}_header_${ARG_BASENAME}_${stem}${extension}")

                    add_test(NAME ${header_test_name}
                        WORKING_DIRECTORY ${render_dir}
                        COMMAND ${CMAKE_COMMAND}
                                "-DOIIO_TOOL=${OIIOTOOL}"
                                "-DCANONICAL=${test_rel_path}/${canonical_exec_mode}/${canonical}"
                                "-DRESULT=${canonical}"
                                -P ${CMAKE_CURRENT_FUNCTION_LIST_DIR}/CompareImageHeaders.cmake
                    )
                    set_tests_properties(${header_test_name} PROPERTIES
                        LABELS "diff"
                        DEPENDS "${render_test_name}"
                        DISABLED ${ARG_DISABLED}
                    )
                endif()

                # diff canonical images
                set(diff_test_name "rats_${exec_mode_short}_diff_${ARG_BASENAME}_${stem}${extension}")
                set(diff_image_name "${stem}_diff${extension}")
                if (EXISTS ${CMAKE_CURRENT_SOURCE_DIR}/diff.cmake)
                    # use custom diff tool
                    add_test(NAME ${diff_test_name}
                        WORKING_DIRECTORY ${render_dir}
                        COMMAND ${CMAKE_COMMAND}
                                "-DCANONICAL=${test_rel_path}/${canonical_exec_mode}/${canonical}"
                                "-DDIFF_IMAGE=${diff_image_name}"
                                "-DEXEC_MODE=${exec_mode}"
                                "-DIDIFF_TOOL=${IDIFF}"
                                "-DOIIO_TOOL=${OIIOTOOL}"
                                "-DDIFF_JSON=${CMAKE_CURRENT_SOURCE_DIR}/diff.json"
                                "-DDIFF_DEFAULTS_JSON=${CMAKE_CURRENT_FUNCTION_LIST_DIR}/diff_defaults.json"
                                "-DRESULT=${canonical}"
                                -P ${CMAKE_CURRENT_SOURCE_DIR}/diff.cmake
                    )
                else()
                    # use idiff
                    add_test(NAME ${diff_test_name}
                        WORKING_DIRECTORY ${render_dir}
                        COMMAND ${CMAKE_COMMAND}
                                "-DCANONICAL=${test_rel_path}/${canonical_exec_mode}/${canonical}"
                                "-DDIFF_IMAGE=${diff_image_name}"
                                "-DEXEC_MODE=${exec_mode}"
                                "-DIDIFF_TOOL=${IDIFF}"
                                "-DDIFF_JSON=${CMAKE_CURRENT_SOURCE_DIR}/diff.json"
                                "-DDIFF_DEFAULTS_JSON=${CMAKE_CURRENT_FUNCTION_LIST_DIR}/diff_defaults.json"
                                "-DRESULT=${canonical}"
                                -P ${CMAKE_CURRENT_FUNCTION_LIST_DIR}/CompareImages.cmake
                    )
                endif() # custom diff
                set_tests_properties(${diff_test_name} PROPERTIES
                    LABELS "diff"
                    DEPENDS ${render_test_name}
                    DISABLED ${ARG_DISABLED}
                )
            endforeach() # canonical
        endif()
    endforeach() # exec mode
endfunction()

