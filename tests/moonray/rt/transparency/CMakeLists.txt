# Copyright 2025 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

# Tests transparency on objects with and without refraction.

add_rats_test(
    INPUTS scene.rdla
    CANONICALS
        scene.exr
        transparency.exr
)

