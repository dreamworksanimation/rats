# Copyright 2024 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

# This tests the independent transmission roughnesses on the refractive lobe.

add_rats_test(BASENAME moonray_material_dwarefractive_independent_roughness
    INPUTS scene.rdla
    CANONICALS
        scene.exr
)

