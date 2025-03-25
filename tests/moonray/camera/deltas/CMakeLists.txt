# Copyright 2025 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

# This test verifies that the camera can be changed with a delta.

add_rats_test(
    INPUTS deltas.rdla
    DELTAS scene.rdla
    CANONICALS
        scene.exr
)

