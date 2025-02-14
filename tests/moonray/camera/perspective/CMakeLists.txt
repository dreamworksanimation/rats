# Copyright 2024 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

# This test exercises PerspectiveCamera

add_rats_test(BASENAME moonray_camera_perspective
    INPUTS scene.rdla
    CANONICALS
        scene.exr
)

