# Copyright 2024 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

# This tests roughness properties of the specular lobe wrt. scaling differentials.

add_rats_test(
    INPUTS scene.rdla
    CANONICALS scene.exr
)

