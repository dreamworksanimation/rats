# Copyright 2024 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

# This tests certain properties of clearcoat.
# (refractive index, thickness, attenuation color, normal)

add_rats_test(BASENAME moonray_material_dwabase_clearcoat_attribute_wedges
    INPUTS scene.rdla
    CANONICALS
        scene.exr
)

