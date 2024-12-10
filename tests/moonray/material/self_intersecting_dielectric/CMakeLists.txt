# Copyright 2024 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

# This tests self-intersecting dielectric materials with priority.

add_rats_test(moonray_material_self_intersecting_dielectric
    INPUTS self_intersecting_dielectric.rdla
    CANONICALS
        scene.exr
)

