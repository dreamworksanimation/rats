# Copyright 2025 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

# This test bakes a result, looking down the normal.

add_rats_test(BASENAME moonray_camera_bake_down_normal
    INPUTS down_normal.rdla
    CANONICALS
        scene.exr
)

