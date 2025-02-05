# Copyright 2024 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

# This tests self-intersecting dielectric materials with priority.

add_rats_test(moonray_material_self_intersecting_dielectric
    INPUTS scene.rdla
    CANONICALS
        scene.exr
)

