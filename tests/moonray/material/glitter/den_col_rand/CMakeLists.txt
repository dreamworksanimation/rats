# Copyright 2024 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

# Test glitter density, color (with variation), and randomness

add_rats_test(moonray_material_glitter_den_col_rand
    INPUTS glitter_den_col_rand.rdla
    CANONICALS
        scene.exr
)

