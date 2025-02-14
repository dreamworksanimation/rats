# Copyright 2024 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

# This tests roughness clamping. Demonstrates how fireflies are eliminated on 
# the torus (change roughness_clamping_factor to 0.0 to see fireflies)

add_rats_test(BASENAME moonray_sampling_roughness_clamping1
    INPUTS scene.rdla
    CANONICALS scene.exr
)
