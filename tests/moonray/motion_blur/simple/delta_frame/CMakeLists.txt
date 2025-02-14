# Copyright 2025 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

# This test checks the motion blur sampling with a delta in frame number

add_rats_test(BASENAME moonray_motion_blur_simple_delta_frame
    INPUTS ../common.rdla
    DELTAS deltas.rdla
    CANONICALS scene.exr
)

