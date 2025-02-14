# Copyright 2024 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

# This tests diffuse flatness on the DwaToonMaterial

add_rats_test(BASENAME moonray_material_dwatoon_diffuseFlatness
    INPUTS scene.rdla
    CANONICALS
        scene.exr
)

