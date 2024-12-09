# Copyright 2024 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

# This tests diffuse flatness on the DwaToonMaterial

add_rats_test(moonray_material_dwatoon_diffuseFlatness
    INPUTS dwatoon_diffuseFlatness.rdla
    CANONICALS
        scene.exr
)

