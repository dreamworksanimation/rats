# Copyright 2024 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

# This tests roughness properties of the specular lobe.

add_rats_test(moonray_material_dwabase_roughness
    INPUTS dwabase_roughness.rdla
    CANONICALS
        scene.exr
)

