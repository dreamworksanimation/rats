# Copyright 2025 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

# This tests more of the worley noise map shader attributes

add_rats_test(
    INPUTS scene.rdla
           ../common.rdla
    CANONICALS scene.exr
)

