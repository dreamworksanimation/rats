# Copyright 2024 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

# Test layering glitter on top of the dwa materials

add_rats_test(BASENAME moonray_material_glitter_layered
    INPUTS scene.rdla
    CANONICALS
        scene.exr
)

