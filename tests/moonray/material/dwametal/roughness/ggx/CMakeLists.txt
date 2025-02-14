# Copyright 2024 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

# This tests roughnesses on the GGX metallic lobe.

add_rats_test(BASENAME moonray_material_dwametal_roughness_ggx
    INPUTS scene.rdla
    CANONICALS
        scene.exr
)

