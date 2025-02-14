# Copyright 2024 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

# This tests the cutout behavior on the ray switch material

add_rats_test(BASENAME moonray_material_rayswitch_cutout
    INPUTS scene.rdla
    CANONICALS
        scene.exr
)

