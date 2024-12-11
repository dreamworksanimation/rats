# Copyright 2024 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

# This tests the ProjectCameraNormalMap

add_rats_test(moonray_map_project_camera_normal
    INPUTS scene.rdla
    CANONICALS scene.exr
)

