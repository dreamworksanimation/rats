# Copyright 2024 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

# This tests the thin geometry parameter with transmission

add_rats_test(moonray_material_dwabase_thin_geometry_transmission
    INPUTS dwabase_thin_geometry_transmission.rdla
    CANONICALS
        scene.exr
)

