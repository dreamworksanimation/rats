# Copyright 2024 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

# Tests motion-blur due to camera translation around the z axis

add_rats_test(BASENAME moonray_motion_blur_camera_tz
    INPUTS ../common.rdla
           scene.rdla
    CANONICALS scene.exr
)

