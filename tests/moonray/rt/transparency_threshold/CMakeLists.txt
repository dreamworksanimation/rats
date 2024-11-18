# Copyright 2024 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

# Tests the transparency threshold on a stack of objects.

add_rats_test(moonray_rt_transparency_threshold
    INPUTS transparency_threshold.rdla
    CANONICALS
        scene.exr
)

