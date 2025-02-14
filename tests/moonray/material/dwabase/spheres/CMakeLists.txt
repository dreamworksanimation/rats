# Copyright 2024 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

# This test verifies reflective properties of materials.

add_rats_test(BASENAME moonray_material_dwabase_spheres
    INPUTS scene.rdla
    CANONICALS
        scene.exr
)

