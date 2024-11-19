# Copyright 2024 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

# Tests camera stereo right view with dof.

add_rats_test(moonray_stereo_right_dof
    INPUTS stereo_right_dof.rdla
    CANONICALS
        scene.exr
)

