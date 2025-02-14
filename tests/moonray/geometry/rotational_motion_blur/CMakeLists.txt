# Copyright 2024 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

# This tests the rotational motion blur

add_rats_test(BASENAME moonray_geometry_rotational_motion_blur
    INPUTS scene.rdla
    CANONICALS
        scene.exr
)

