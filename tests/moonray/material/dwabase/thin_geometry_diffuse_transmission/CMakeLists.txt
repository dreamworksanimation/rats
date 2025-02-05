# Copyright 2024 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

# This tests the thin geometry parameter with diffuse transmission

add_rats_test(moonray_material_dwabase_thin_geometry_diffuse_transmission
    INPUTS scene.rdla
    CANONICALS
        scene.exr
)

