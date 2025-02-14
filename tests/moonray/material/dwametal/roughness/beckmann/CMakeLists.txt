# Copyright 2024 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

# This tests roughnesses on the Beckmann

add_rats_test(BASENAME moonray_material_dwametal_roughness_beckmann
    INPUTS scene.rdla
    CANONICALS
        scene.exr
)

