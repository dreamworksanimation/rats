# Copyright 2024 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

# This test exercises overlapping lights

add_rats_test(moonray_light_overlapping_lights
    INPUTS scene.rdla
    CANONICALS
        scene.exr
)

