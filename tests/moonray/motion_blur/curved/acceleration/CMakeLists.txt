# Copyright 2024 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

# This test exercises the quadratic 'acceleration' type of curved motion blur

add_rats_test(moonray_motion_blur_curved_acceleration
    INPUTS scene.rdla
    CANONICALS scene.exr
)

