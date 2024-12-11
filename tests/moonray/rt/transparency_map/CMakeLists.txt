# Copyright 2024 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

# Tests transparency on objects specified via a map.

add_rats_test(moonray_rt_transparency_map
    INPUTS transparency_map.rdla
    CANONICALS
        scene.exr
)

