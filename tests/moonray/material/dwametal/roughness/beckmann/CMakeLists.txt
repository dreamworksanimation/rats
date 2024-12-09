# Copyright 2024 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

# This tests roughnesses on the Beckmann

add_rats_test(moonray_material_dwametal_roughness_beckmann
    INPUTS dwametal_roughness_beckmann.rdla
    CANONICALS
        scene.exr
)

