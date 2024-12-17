# Copyright 2023 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

# This tests the HairToonMaterial

add_rats_test(moonray_material_hair_toon
    INPUTS scene.rdla
    CANONICALS scene.exr
)

