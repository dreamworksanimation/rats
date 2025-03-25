# Copyright 2024 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

# This tests the "max_subsurface_per_path" depth-based scene variable.

add_rats_test(
    INPUTS scene.rdla
    CANONICALS
        scene.exr
)

