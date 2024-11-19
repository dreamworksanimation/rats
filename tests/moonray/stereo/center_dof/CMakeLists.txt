# Copyright 2024 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

# Tests camera stereo center view with dof.

add_rats_test(moonray_stereo_center_dof
    INPUTS stereo_center_dof.rdla
    CANONICALS
        scene.exr
)

