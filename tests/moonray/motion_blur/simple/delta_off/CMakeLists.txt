# Copyright 2025 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

# This test checks the motion blur sampling with a delta that turns it off

add_rats_test(moonray_motion_blur_simple_delta_off
    INPUTS ../common.rdla
    DELTAS deltas.rdla
    CANONICALS scene.exr
)

