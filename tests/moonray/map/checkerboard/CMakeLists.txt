# Copyright 2024 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

# This tests the checkerboard map shader

add_rats_test(moonray_map_checkerboard
    INPUTS checkerboard.rdla
    CANONICALS scene.exr
)

