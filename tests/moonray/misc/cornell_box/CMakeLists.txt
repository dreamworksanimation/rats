# Copyright 2023 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

add_rats_test(misc_cornell_box
    SCENE_DIR ${CMAKE_CURRENT_SOURCE_DIR}
    INPUTS
        scene.rdla
    OUTPUTS
        scene.exr
)

