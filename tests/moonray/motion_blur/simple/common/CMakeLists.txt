# Copyright 2025 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

# This test checks the motion blur sampling

add_rats_test(moonray_motion_blur_simple_common
    INPUTS scene.rdla
    CANONICALS scene.exr
)

