# Copyright 2024 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

# Tests motion-blur camera shutter settings with deltas

add_rats_test(BASENAME moonray_motion_blur_camera_shutter_delta
    INPUTS ../common.rdla
           scene.rdla
    DELTAS deltas.rdla
    CANONICALS scene.exr
)

