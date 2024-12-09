# Copyright 2024 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

# This tests extending the ramp on DwaToonMaterial, in conjunction with prevent_light_culling

add_rats_test(moonray_material_dwatoon_extend_ramp
    INPUTS dwatoon_extend_ramp.rdla
    CANONICALS
        scene.exr
)

