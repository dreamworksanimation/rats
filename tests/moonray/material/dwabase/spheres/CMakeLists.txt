# Copyright 2024 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

# This test verifies reflective properties of materials.

add_rats_test(moonray_material_dwabase_spheres
    INPUTS dwabase_spheres.rdla
    CANONICALS
        scene.exr
)

