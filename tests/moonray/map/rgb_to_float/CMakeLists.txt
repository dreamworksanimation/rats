# Copyright 2024 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

# This test verifies RgbToFloat map conversion functionality (R, G, B, Min, Max, Average, Sum, Luminance)

add_rats_test(moonray_map_rgb_to_float
    INPUTS scene.rdla
    CANONICALS scene.exr
)

