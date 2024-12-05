# Copyright 2024 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

# This tests the thin geometry parameter with reflection

add_rats_test(moonray_material_dwabase_thin_geometry_reflection
    INPUTS dwabase_thin_geometry_reflection.rdla
    CANONICALS
        scene.exr
)

