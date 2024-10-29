# Copyright 2024 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

# This tests adaptive tessellation with resolution uniform tessellation can't handle

add_rats_test(moonray_geometry_adaptive_tessellation
    INPUTS adaptive_tessellation.rdla
    CANONICALS
        scene.exr
)

