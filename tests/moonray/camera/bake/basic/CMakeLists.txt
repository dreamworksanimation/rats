# Copyright 2025 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

# This test bakes the lighting on the plane mesh geometry.

add_rats_test(BASENAME moonray_camera_bake_basic
    INPUTS basic.rdla
    CANONICALS
        scene.exr
)

