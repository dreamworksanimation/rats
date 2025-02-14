# Copyright 2024 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

# This tests DwaTwoSidedMaterial's basic functionality

add_rats_test(BASENAME moonray_material_dwatwosided
    INPUTS scene.rdla
    CANONICALS
        scene.exr
)

