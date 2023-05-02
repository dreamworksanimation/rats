# Copyright 2023 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

set(test_basename bathroom)
set(test_dir /usr/pic1/jlanz/pbrt_scenes/bathroom/)


set(exec_modes scalar;vector;xpu)
foreach(exec_mode ${exec_modes})
    set(test_name ${test_basename}_${exec_mode})

    # this test generates the canonicals
    add_test(NAME ${test_name}_canonicals
        WORKING_DIRECTORY ${test_dir}
        COMMAND moonray
            -exec_mode ${exec_mode}
            -in scene.rdla
            -in scene.rdlb
            -res ${RATS_RENDER_RES}
            -threads ${RATS_NUM_THREADS}
            -out ${RATS_CANONICAL_PATH}/${test_name}.exr
    )
    set_tests_properties(${test_name}_canonicals PROPERTIES
        LABELS "canonicals"
        ENVIRONMENT
            RDL2_DSO_PATH=${CMAKE_BINARY_DIR}/rdl2dso/
    )

    # this test renders the result
    add_test(NAME ${test_name}_render
        WORKING_DIRECTORY ${test_dir}
        COMMAND moonray
            -exec_mode ${exec_mode}
            -in scene.rdla
            -in scene.rdlb
            -res ${RATS_RENDER_RES}
            -threads ${RATS_NUM_THREADS}
            -out ${CMAKE_CURRENT_BINARY_DIR}/${test_name}.exr
    )
    set_tests_properties(${test_name}_render PROPERTIES
        FIXTURES_SETUP ${test_name}_render
        LABELS "rats"
        ENVIRONMENT
            RDL2_DSO_PATH=${CMAKE_BINARY_DIR}/rdl2dso/
    )


    # this test diffs the result with the canonical
    add_test(NAME ${test_name}_diff
        WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
        COMMAND oiiotool -i ${test_name}.exr --diff -i ${RATS_CANONICAL_PATH}/${test_name}.exr
    )
    set_tests_properties(${test_name}_diff PROPERTIES
        LABELS "rats"
        FIXTURES_REQUIRED ${test_name}_render
    )
endforeach()
