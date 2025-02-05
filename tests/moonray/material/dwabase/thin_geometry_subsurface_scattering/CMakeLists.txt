# Copyright 2024 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

# This tests the thin geometry parameter with subsurface scattering

add_rats_test(moonray_material_dwabase_thin_geometry_subsurface_scattering
    INPUTS scene.rdla
    CANONICALS
        scene.exr
)

