# Copyright 2023 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

set(testName rats_bathroom)

add_test(NAME ${testName}
    WORKING_DIRECTORY /usr/pic1/jlanz/pbrt_scenes/bathroom/
    COMMAND moonray
        -exec_mode scalar
        -info
        -in scene.rdla
        -in scene.rdlb
        -res 4
        -out ${CMAKE_CURRENT_BINARY_DIR}/scene.exr
)
set_tests_properties(${testName} PROPERTIES
    # RUN_SERIAL TRUE
    FIXTURES_SETUP ${testName}_render
    LABELS "rats"
    ENVIRONMENT
        RDL2_DSO_PATH=${CMAKE_BINARY_DIR}/rdl2dso/
)

add_test(NAME ${testName}_diff
    WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
    COMMAND oiiotool -i scene.exr --diff -i scene.exr
)
set_tests_properties(${testName}_diff PROPERTIES
    FIXTURES_REQUIRED ${testName}_render
)
