# Copyright 2024 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

# This test verifies that the AxisAngleMap is working. This tests rotation of the shading normals 
# about a world space and object space axis.

add_rats_test(
    INPUTS scene.rdla
    CANONICALS scene.exr
)

