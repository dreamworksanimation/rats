# Copyright 2024 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

# Test the blending algorithm of glitter material

add_rats_test(BASENAME moonray_material_glitter_blend
    INPUTS scene.rdla
    CANONICALS
        scene.exr
)

