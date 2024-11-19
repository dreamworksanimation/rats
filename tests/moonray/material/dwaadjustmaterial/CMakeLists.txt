# Copyright 2024 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

# Tests a number of dwaadjustmaterial parameters using attributes

add_rats_test(moonray_material_dwaadjustmaterial
    INPUTS dwaadjustmaterial.rdla
    CANONICALS
        scene.exr
)

