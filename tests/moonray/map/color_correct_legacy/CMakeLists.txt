# Copyright 2024 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

# This tests the ColorCorrectLegacyMap

add_rats_test(moonray_map_color_correct_legacy
    INPUTS scene.rdla
    CANONICALS scene.exr
)

