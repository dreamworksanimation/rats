# Copyright 2024 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

# Tests the transparency threshold on a stack of objects.

add_rats_test(BASENAME moonray_rt_transparency_threshold
    INPUTS scene.rdla
    CANONICALS
        scene.exr
)

