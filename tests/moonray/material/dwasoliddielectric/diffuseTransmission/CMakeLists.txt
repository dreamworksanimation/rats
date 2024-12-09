# Copyright 2024 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

# This tests diffuse transmission.

add_rats_test(moonray_material_dwasoliddielectric_diffuseTransmission
    INPUTS dwasoliddielectric_diffuseTransmission.rdla
    CANONICALS
        scene.exr
)

