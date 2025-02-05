# Copyright 2024 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

# This tests the checkerboard map shader

add_rats_test(moonray_map_checkerboard
    INPUTS scene.rdla
    CANONICALS scene.exr
)

