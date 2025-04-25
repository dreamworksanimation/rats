# Copyright 2025 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

# This tests roughness clamping. Demonstrates how fireflies are eliminated on
# the plane (change roughness_clamping_factor to 0.0 to see fireflies)

add_rats_test(
    INPUTS ../roughness_clamping1/scene.rdla
           scene.rdla
    CANONICALS scene.exr
)
