# Copyright 2023 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

# Furnace Test for HairMaterial.

add_rats_test(moonray_material_hair_furnace
    INPUTS scene.rdla
    CANONICALS scene.exr
)

