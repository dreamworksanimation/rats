# Copyright 2025 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

# This tests the noise map features

add_rats_test(
    INPUTS scene.rdla
           ../common.rdla
    CANONICALS scene.exr
)

