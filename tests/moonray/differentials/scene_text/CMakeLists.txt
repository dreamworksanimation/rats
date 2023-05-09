# Copyright 2023 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

add_rats_test(differentials_scene_text
    SCENE_DIR ${CMAKE_CURRENT_SOURCE_DIR}
    INPUTS
        scene.rdla
    OUTPUTS
        scene.exr
    # IDIFF_ARGS_VECTOR -fail 0.05 -failpercent 2 -warn 0.09
    # IDIFF_ARGS_XPU    -fail 0.05 -failpercent 2 -warn 0.09
)



