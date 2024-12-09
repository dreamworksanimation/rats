# Copyright 2024 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

# This tests fuzz on metal

add_rats_test(moonray_material_dwametal_fuzz
    INPUTS dwametal_fuzz.rdla
    CANONICALS
        scene.exr
)

