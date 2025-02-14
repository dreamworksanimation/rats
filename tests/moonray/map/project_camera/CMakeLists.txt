# Copyright 2024 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

# This tests the ProjectCameraMap_v2 with various projectors and options

add_rats_test(BASENAME moonray_map_project_camera_projectors
    INPUTS scene.rdla
    CANONICALS scene.exr
)

