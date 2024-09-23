# Copyright 2024 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

# This test exercises the spread parameter on the rect and disk light.

add_rats_test(moonray_light_spread
    INPUTS spread.rdla
    CANONICALS
        scene.exr
)

