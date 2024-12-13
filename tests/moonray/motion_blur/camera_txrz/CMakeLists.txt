# Copyright 2024 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

# Tests motion-blur due to camera translation and rotation

add_rats_test(moonray_motion_blur_camera_txrz
    INPUTS ../common/motion_blur_common.rdla
           motion_blur_camera_txrz.rdla
    CANONICALS scene.exr
)

