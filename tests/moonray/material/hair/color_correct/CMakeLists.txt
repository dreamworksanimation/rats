# Copyright 2023 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

# This tests the ColorCorrect material for hair.

add_rats_test(BASENAME moonray_material_hair_color_correct
    INPUTS scene.rdla
    CANONICALS scene.exr
)

