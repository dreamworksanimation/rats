# Copyright 2024 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

# This test the light accelerator

add_rats_test(BASENAME moonray_light_accelerator
    INPUTS scene.rdla
    CANONICALS
        scene.exr
)

