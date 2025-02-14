# Copyright 2024 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

# Tests camera stereo center view with dof.

add_rats_test(BASENAME moonray_stereo_center_dof
    INPUTS scene.rdla
    CANONICALS
        scene.exr
)

