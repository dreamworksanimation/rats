# Copyright 2024 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

# Tests motion-blur due to changing camera focal length

add_rats_test(moonray_motion_blur_camera_focal
    INPUTS ../common.rdla
           scene.rdla
    CANONICALS scene.exr
)

