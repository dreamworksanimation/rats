# Copyright 2025 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

# This test bakes a sphere along its normals.

add_rats_test(BASENAME moonray_camera_bake_normal
    INPUTS normal.rdla
    CANONICALS
        scene.exr
)

