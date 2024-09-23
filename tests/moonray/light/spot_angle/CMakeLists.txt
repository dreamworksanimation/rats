# Copyright 2024 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

# This tests the cone angle in relation to the spot area.

add_rats_test(moonray_light_spot_angle
    INPUTS spot_angle.rdla
    CANONICALS
        scene.exr
)

