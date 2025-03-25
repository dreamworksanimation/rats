# Copyright 2024 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

# This tests index of refraction of the specular lobe.

add_rats_test(
    INPUTS scene.rdla
    CANONICALS
        scene.exr
)

