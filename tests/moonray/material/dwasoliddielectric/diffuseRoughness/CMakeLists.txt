# Copyright 2024 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

#  This tests diffuse roughness and the Oren-Nayar diffuse model

add_rats_test(
    INPUTS scene.rdla
    CANONICALS
        scene.exr
)

