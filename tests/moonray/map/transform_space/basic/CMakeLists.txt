# Copyright 2024 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

# This tests the transform space map shader

add_rats_test(BASENAME moonray_map_transform_space_basic
    INPUTS scene.rdla
    CANONICALS scene.exr
)

