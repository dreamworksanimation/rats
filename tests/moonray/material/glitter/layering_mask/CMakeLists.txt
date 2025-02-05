# Copyright 2024 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

# Test layering of glitter over another material at various densities and masking as well as physical vs additive modes

add_rats_test(moonray_material_glitter_layering_mask
    INPUTS scene.rdla
    CANONICALS
        scene.exr
)

