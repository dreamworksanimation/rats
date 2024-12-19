# Copyright 2024 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

# Test Velvet_v2 Shader

add_rats_test(moonray_material_dwavelvet_beauty
    INPUTS scene.rdla
    CANONICALS
        scene.exr
)

