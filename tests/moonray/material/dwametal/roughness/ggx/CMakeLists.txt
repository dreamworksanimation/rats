# Copyright 2024 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

# This tests roughnesses on the GGX metallic lobe.

add_rats_test(moonray_material_dwametal_roughness_ggx
    INPUTS dwametal_roughness_ggx.rdla
    CANONICALS
        scene.exr
)

