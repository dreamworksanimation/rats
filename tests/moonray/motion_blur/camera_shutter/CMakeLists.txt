# Copyright 2024 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

# Tests motion-blur camera shutter settings

add_rats_test(BASENAME moonray_motion_blur_camera_shutter
    INPUTS ../common.rdla
           scene.rdla
    CANONICALS scene.exr
)

