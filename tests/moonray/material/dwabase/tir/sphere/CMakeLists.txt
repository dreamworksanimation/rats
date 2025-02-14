# Copyright 2024 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

# This tests total internal reflection

add_rats_test(BASENAME moonray_material_dwabase_tir_sphere
    INPUTS scene.rdla
    CANONICALS
        scene.exr
)

