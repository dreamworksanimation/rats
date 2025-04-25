# Copyright 2025 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

# Tests the wireframe output.

add_rats_test(
    INPUTS scene.rdla
    CANONICALS
        scene.exr
        wireframe.exr
)

