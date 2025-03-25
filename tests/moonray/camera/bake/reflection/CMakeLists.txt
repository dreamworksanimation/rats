# Copyright 2025 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

# This test bakes along the reflection vector of the plane.

add_rats_test(
    INPUTS reflection.rdla
    CANONICALS
        scene.exr
)

