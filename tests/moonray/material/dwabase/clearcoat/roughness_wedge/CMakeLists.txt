# Copyright 2024 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

# This tests roughness properties of the clearcoat lobe.

add_rats_test(BASENAME moonray_material_dwabase_clearcoat_roughness_wedge
    INPUTS scene.rdla
    CANONICALS
        scene.exr
)

