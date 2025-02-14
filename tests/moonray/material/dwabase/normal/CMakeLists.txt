# Copyright 2024 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

# This tests basic normal mapping

add_rats_test(BASENAME moonray_material_dwabase_normal
    INPUTS scene.rdla
    CANONICALS
        scene.exr
)

