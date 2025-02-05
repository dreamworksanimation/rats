# Copyright 2025 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

# This test checks the motion blur sampling with a delta that turns it off using an orthographic camera

add_rats_test(moonray_motion_blur_simple_delta_off_ortho
    INPUTS ../common.rdla
    DELTAS deltas.rdla
    CANONICALS scene.exr
)

