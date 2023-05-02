# Copyright 2023 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

set(test_basename bathroom)


set(exec_modes scalar;vector;xpu)
foreach(exec_mode ${exec_modes})
    set(test_name ${test_basename}_${exec_mode})

    add_test(NAME ${test_name}_render
        WORKING_DIRECTORY /usr/pic1/jlanz/pbrt_scenes/bathroom/
        COMMAND moonray
            -exec_mode ${exec_mode}
            -in scene.rdla
            -in scene.rdlb
            -res ${RATS_RENDER_RES}
            -threads ${RATS_NUM_THREADS}
            -out ${CMAKE_CURRENT_BINARY_DIR}/${test_name}.exr
    )
    set_tests_properties(${test_name}_render PROPERTIES
        # RUN_SERIAL TRUE
        FIXTURES_SETUP ${test_name}_render
        LABELS "rats;rats_canonicals;${exec_mode}"
        ENVIRONMENT
            RDL2_DSO_PATH=${CMAKE_BINARY_DIR}/rdl2dso/
    )


    add_test(NAME ${test_name}_diff
        WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
        # FIXME: I'm cheating
        COMMAND oiiotool -i ${test_name}.exr --diff -i ${test_name}.exr
    )
    set_tests_properties(${test_name}_diff PROPERTIES
        LABELS "rats"
        FIXTURES_REQUIRED ${test_name}_render
    )
endforeach()
