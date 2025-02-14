# Copyright 2024 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

# This tests the transform space map shader with tangent space inputs

add_rats_test(BASENAME moonray_map_transform_space_tangent
    INPUTS scene.rdla
    CANONICALS scene.exr
)

