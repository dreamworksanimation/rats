# Copyright 2024 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

# This tests roughnesses on the refractive lobe.

add_rats_test(moonray_material_dwarefractive_roughness
    INPUTS dwarefractive_roughness.rdla
    CANONICALS
        scene.exr
)

