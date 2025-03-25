# Copyright 2024 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

# This test verifies shading with explicit attributes on various geometry types

add_rats_test(
    INPUTS scene.rdla
    CANONICALS
        scene.exr
)

