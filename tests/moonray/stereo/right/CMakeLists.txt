# Copyright 2024 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

# Tests camera stereo right view.

add_rats_test(moonray_stereo_right
    INPUTS stereo_right.rdla
    CANONICALS
        scene.exr
)

