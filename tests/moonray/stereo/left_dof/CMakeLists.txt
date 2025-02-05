# Copyright 2024 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

# Tests camera stereo left view with dof.

add_rats_test(moonray_stereo_left_dof
    INPUTS scene.rdla
    CANONICALS
        scene.exr
)

