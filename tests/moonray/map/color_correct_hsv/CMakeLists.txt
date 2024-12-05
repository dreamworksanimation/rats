# Copyright 2024 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

# This tests the ColorCorrectHsvMap

add_rats_test(moonray_map_color_correct_hsv
    INPUTS scene.rdla
    CANONICALS scene.exr
)

