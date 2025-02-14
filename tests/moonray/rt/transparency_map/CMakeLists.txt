# Copyright 2024 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

# Tests transparency on objects specified via a map.

add_rats_test(BASENAME moonray_rt_transparency_map
    INPUTS scene.rdla
    CANONICALS
        scene.exr
)

