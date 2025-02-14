# Copyright 2023 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

# Test the HairDiffuseMaterial Features.

add_rats_test(BASENAME moonray_material_hair_diffuse
    INPUTS scene.rdla
    CANONICALS scene.exr
)

