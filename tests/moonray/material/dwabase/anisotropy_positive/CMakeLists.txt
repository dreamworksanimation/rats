# Copyright 2024 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

# This tests anisotropy properties of the specular lobe using 
# Cook-Torrance with Beckmann distribution using positive values

add_rats_test(
    INPUTS scene.rdla
    CANONICALS
        scene.exr
)

