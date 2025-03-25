# Copyright 2024 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

# This tests the texture filter scale with a checker texture.
# It uses a specialized texture which has a different image at 
# each mip level.  This allows us to see how mip levels are determined
# by the mip selector (or even the differential) algorithms.

add_rats_test(
    INPUTS scene.rdla
    CANONICALS scene.exr
)
