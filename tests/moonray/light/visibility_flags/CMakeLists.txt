# Copyright 2024 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

# Tests the visibility flags of a light.

add_rats_test(moonray_light_visibility_flags
    INPUTS scene.rdla
    CANONICALS
        scene.exr
)

