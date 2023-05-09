# Copyright 2023 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

set(rats_default_idiff_args_scalar
    -fail 0.004           # Failure absolute difference threshold (default: 1e-06)
    # -failrelative 0       # Failure relative threshold (default: 0)
    -failpercent 0.01     # Allow this percentage of failures (default: 0)
    -hardfail 0.02        # Fail if any one pixel exceeds this error (default: inf)
    # -allowfailures 1e-06  # OK for this number of pixels to fail by any amount (default: 0)
    -warn 0.004           # Warning absolute difference threshold (default: 1e-06)
    # -warnrelative 0       # Warning relative threshold (default: 0)
    -warnpercent 0.01        # Allow this percentage of warnings (default: 0)
    # -hardwarn inf         # Warn if any one pixel exceeds this error (default: inf)
    # -scale 1              # Scale the output image by this factor (default: 1)
    # -p                    # Perform perceptual (rather than numeric) comparison
)

set(rats_default_idiff_args_vector
    -fail 0.004           # Failure absolute difference threshold (default: 1e-06)
    # -failrelative 0       # Failure relative threshold (default: 0)
    -failpercent 0.2      # Allow this percentage of failures (default: 0)
    -hardfail 0.02        # Fail if any one pixel exceeds this error (default: inf)
    # -allowfailures 1e-06  # OK for this number of pixels to fail by any amount (default: 0)
    -warn 0.004           # Warning absolute difference threshold (default: 1e-06)
    # -warnrelative 0       # Warning relative threshold (default: 0)
    -warnpercent 0.2         # Allow this percentage of warnings (default: 0)
    # -hardwarn inf         # Warn if any one pixel exceeds this error (default: inf)
    # -scale 1              # Scale the output image by this factor (default: 1)
    # -p                    # Perform perceptual (rather than numeric) comparison
)

set(rats_default_idiff_args_xpu
    -fail 0.004           # Failure absolute difference threshold (default: 1e-06)
    # -failrelative 0       # Failure relative threshold (default: 0)
    -failpercent 0.2      # Allow this percentage of failures (default: 0)
    -hardfail 0.02        # Fail if any one pixel exceeds this error (default: inf)
    # -allowfailures 1e-06  # OK for this number of pixels to fail by any amount (default: 0)
    -warn 0.004           # Warning absolute difference threshold (default: 1e-06)
    # -warnrelative 0       # Warning relative threshold (default: 0)
    -warnpercent 0.2         # Allow this percentage of warnings (default: 0)
    # -hardwarn inf         # Warn if any one pixel exceeds this error (default: inf)
    # -scale 1              # Scale the output image by this factor (default: 1)
    # -p                    # Perform perceptual (rather than numeric) comparison
)

function(add_rats_test test_basename)
    set(options "") # unused
    set(oneValueArgs SCENE_DIR)
    set(multiValueArgs
            INPUTS
            OUTPUTS
            IDIFF_ARGS_SCALAR
            IDIFF_ARGS_VECTOR
            IDIFF_ARGS_XPU
            RENDER_ARGS_SCALAR
            RENDER_ARGS_VECTOR
            RENDER_ARGS_XPU
    )
    cmake_parse_arguments(ARG "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})

    if (ARG_SCENE_DIR)
        set(scene_dir ${ARG_SCENE_DIR})
    else()
        set(scene_dir ${CMAKE_CURRENT_SOURCE_DIR})
    endif()

    set(rdl2_dso_path ${CMAKE_BINARY_DIR}/rdl2dso/)
    set(rats_assets_dir ${PROJECT_SOURCE_DIR}/assets/)

    file(RELATIVE_PATH test_rel_path ${PROJECT_SOURCE_DIR}/tests/ ${CMAKE_CURRENT_SOURCE_DIR})
    set(root_canonical_path ${RATS_CANONICAL_PATH}/${test_rel_path})

    foreach(exec_mode scalar;vector;xpu)
        set(canonical_dir ${root_canonical_path}/${exec_mode})
        set(render_dir ${CMAKE_CURRENT_BINARY_DIR}/${exec_mode})
        file(MAKE_DIRECTORY ${render_dir})

        set(canonical_test_name "rats_${exec_mode}_canonical_${test_basename}")
        set(render_test_name "rats_${exec_mode}_render_${test_basename}")

        # Build moonray command. We need the fully qualified path to the moonray executable if
        # we are going to be running it using the ${CMAKE_COMMAND} -P <script.cmake> method.
        # NOTE: $<TARGET_FILE:moonray> isn't expanded until _build_ time.
        set(render_cmd $<TARGET_FILE:moonray>)

        foreach(rdl_input ${ARG_INPUTS})
            list(APPEND render_cmd -in ${scene_dir}/${rdl_input})
        endforeach()
        list(APPEND render_cmd -exec_mode ${exec_mode})
        list(APPEND render_cmd -rdla_set "rats_assets_dir" "[[${rats_assets_dir}]]")

        if (${exec_mode} STREQUAL scalar)
            list(APPEND render_cmd ${ARG_RENDER_ARGS_SCALAR})
        elseif (${exec_mode} STREQUAL vector)
            list(APPEND render_cmd ${ARG_RENDER_ARGS_VECTOR})
        elseif (${exec_mode} STREQUAL xpu)
            list(APPEND render_cmd ${ARG_RENDER_ARGS_XPU})
        endif()
        message(VERBOSE "${render_cmd}")

        # Add test to generate canonicals
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
            ENVIRONMENT RDL2_DSO_PATH=${rdl2_dso_path}
        )

        # Add test to render result
        add_test(NAME ${render_test_name}
            WORKING_DIRECTORY ${render_dir}
            COMMAND ${render_cmd}
        )
        set_tests_properties(${render_test_name} PROPERTIES
            LABELS "render"
            ENVIRONMENT RDL2_DSO_PATH=${rdl2_dso_path}
        )

        # Add test to diff the result with the canonical via oiiotool
        foreach(output ${ARG_OUTPUTS})
            cmake_path(GET output STEM stem)
            cmake_path(GET output EXTENSION extension)
            set(diff_test_name "rats_${exec_mode}_diff_${test_basename}_${stem}")
            set(diff_name "${stem}_diff${extension}")

            set(diff_args -o ${diff_name})
            if (${exec_mode} STREQUAL scalar)
                list(APPEND diff_args ${rats_default_idiff_args_scalar})
                list(APPEND diff_args ${ARG_IDIFF_ARGS_SCALAR})
            elseif (${exec_mode} STREQUAL vector)
                list(APPEND diff_args ${rats_default_idiff_args_vector})
                list(APPEND diff_args ${ARG_IDIFF_ARGS_VECTOR})
            elseif (${exec_mode} STREQUAL xpu)
                list(APPEND diff_args ${rats_default_idiff_args_xpu})
                list(APPEND diff_args ${ARG_IDIFF_ARGS_XPU})
            endif()
            message(VERBOSE "${diff_args}")

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

