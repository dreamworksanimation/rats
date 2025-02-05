# Copyright 2025 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

# This test checks the motion blur sampling with a camera-transform delta

add_rats_test(moonray_motion_blur_simple_delta_xform
    INPUTS ../common.rdla
    DELTAS deltas.rdla
    CANONICALS scene.exr
)

