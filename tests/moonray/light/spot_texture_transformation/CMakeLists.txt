# Copyright 2024 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

# This test exercises texture transformation controls for a spotlight.

add_rats_test(moonray_light_spot_texture_transformation
    INPUTS spot_texture_transformation.rdla
    CANONICALS
        scene.exr
)

