# Copyright 2024 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

# This tests the switch float map shader

add_rats_test(moonray_map_switch_float
    INPUTS switch_float.rdla
    CANONICALS scene.exr
)

