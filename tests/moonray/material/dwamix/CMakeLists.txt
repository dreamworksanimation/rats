# Copyright 2024 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

# This tests the DwaMixMaterial

add_rats_test(moonray_material_dwamix
    INPUTS dwamix.rdla
    CANONICALS
        scene.exr
)

