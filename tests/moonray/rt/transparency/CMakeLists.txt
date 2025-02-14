# Copyright 2024 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

# Tests transparency on objects with and without refraction.

add_rats_test(BASENAME moonray_rt_transparency
    INPUTS scene.rdla
    CANONICALS
        scene.exr
        transparency.exr
)

