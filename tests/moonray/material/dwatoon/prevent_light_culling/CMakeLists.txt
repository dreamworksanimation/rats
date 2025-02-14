# Copyright 2024 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

# This tests disabling of light culling on the DwaToonMaterial

add_rats_test(BASENAME moonray_material_dwatoon_prevent_light_culling
    INPUTS scene.rdla
    CANONICALS
        scene.exr
)

