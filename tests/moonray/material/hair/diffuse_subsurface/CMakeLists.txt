# Copyright 2023 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

# This test checks SSS settings on the hair diffuse material.

add_rats_test(BASENAME moonray_material_hair_diffuse_subsurface
    INPUTS scene.rdla
    CANONICALS scene.exr
)

