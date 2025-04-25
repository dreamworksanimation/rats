# Copyright 2025 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

# This test exercises transform and deformation motion blur in the mesh light.

add_rats_test(
    INPUTS scene.rdla
    CANONICALS
        scene.exr
)

