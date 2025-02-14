# Copyright 2024 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

# This tests defaults properties of the base material

add_rats_test(BASENAME moonray_material_dwabase_defaults
    INPUTS scene.rdla
    CANONICALS
        scene.exr
)

