# Copyright 2024 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

# This tests the ColorCorrectMap

add_rats_test(moonray_map_color_correct
    INPUTS scene.rdla
    CANONICALS scene.exr
)

