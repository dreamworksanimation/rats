# Copyright 2024 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

# This tests the ray switch material

add_rats_test(moonray_material_rayswitch_basic
    INPUTS scene.rdla
    CANONICALS
        scene.exr
)

