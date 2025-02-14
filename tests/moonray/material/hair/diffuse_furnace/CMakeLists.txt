# Copyright 2023 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

# Furnace Test for HairDiffuse.

add_rats_test(BASENAME moonray_material_hair_diffuse_furnace
    INPUTS scene.rdla
    CANONICALS scene.exr
)

