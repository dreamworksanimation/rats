# Copyright 2025 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

# This tests total internal reflection

add_rats_test(moonray_material_dwabase_tir_cup
    INPUTS scene.rdla
    CANONICALS
        scene.exr
)

