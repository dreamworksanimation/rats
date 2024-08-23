# Copyright 2024 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

# This test exercises OrthographicCamera

add_rats_test(moonray_camera_orthographic
    INPUTS scene.rdla
    CANONICALS
        scene.exr
)

