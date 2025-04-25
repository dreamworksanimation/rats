# Copyright 2025 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

# This tests roughness properties of the specular lobe.

add_rats_test(
    INPUTS scene.rdla
    CANONICALS
        scene.exr
)

