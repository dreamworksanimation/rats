# Copyright 2024 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

# This tests all the properties of the dwabase material

add_rats_test(moonray_material_dwabase_basic
    INPUTS scene.rdla
    CANONICALS
        scene.exr
)

