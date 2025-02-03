# Copyright 2025 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

# This test bakes a map on a subd mesh using a non-default uv.

add_rats_test(moonray_camera_bake_subd
    INPUTS subd.rdla
    CANONICALS
        scene.exr
)

