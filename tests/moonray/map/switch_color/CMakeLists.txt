# Copyright 2024 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

# This tests the switch color map shader

add_rats_test(BASENAME moonray_map_switch_color
    INPUTS scene.rdla
    CANONICALS scene.exr
)

