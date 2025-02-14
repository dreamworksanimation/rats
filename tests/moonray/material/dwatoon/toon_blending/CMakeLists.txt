# Copyright 2024 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

# This tests blending interactions between toon and base diffuse

add_rats_test(BASENAME moonray_material_dwatoon_toon_blending
    INPUTS scene.rdla
    CANONICALS
        scene.exr
)

