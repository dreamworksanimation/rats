# Copyright 2025 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

# This test verifies RgbToFloat map conversion functionality (R, G, B, Min, Max, Average, Sum, Luminance)

add_rats_test(
    INPUTS scene.rdla
    CANONICALS scene.exr
)

