# Copyright 2024 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

# This tests transmission roughness

add_rats_test(moonray_material_dwabase_transmission_roughness
    INPUTS dwabase_transmission_roughness.rdla
    CANONICALS
        scene.exr
)

