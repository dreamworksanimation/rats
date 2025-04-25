# Copyright 2025 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

# This tests self-intersecting dielectric materials with priority.

add_rats_test(
    INPUTS scene.rdla
    CANONICALS
        scene.exr
)

