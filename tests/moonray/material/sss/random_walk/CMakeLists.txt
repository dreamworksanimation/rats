# Copyright 2024 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

# This tests random_walk Path Traced SSS.

add_rats_test(moonray_material_sss_random_walk
    INPUTS scene.rdla
    CANONICALS
        scene.exr
)

