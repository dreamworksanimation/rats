# Copyright 2024 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

# This tests the cutout behavior on the ray switch material

add_rats_test(moonray_material_rayswitch_cutout
    INPUTS rayswitch_cutout.rdla
    CANONICALS
        scene.exr
)

