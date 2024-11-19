# Copyright 2024 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

# Tests camera stereo left view.

add_rats_test(moonray_stereo_left
    INPUTS stereo_left.rdla
    CANONICALS
        scene.exr
)

