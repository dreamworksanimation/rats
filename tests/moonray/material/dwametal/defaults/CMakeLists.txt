# Copyright 2024 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

# This tests default properties of the DwaMetal material

add_rats_test(moonray_material_dwametal_defaults
    INPUTS dwametal_defaults.rdla
    CANONICALS
        scene.exr
)

