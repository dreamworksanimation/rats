# Copyright 2024 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

# This tests Fuzz on DwaBase material

add_rats_test(BASENAME moonray_material_dwabase_fuzz
    INPUTS scene.rdla
    CANONICALS
        scene.exr
)

