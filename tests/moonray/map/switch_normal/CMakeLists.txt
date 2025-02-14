# Copyright 2024 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

# This tests the SwitchNormalMap

add_rats_test(BASENAME moonray_map_switch_normal
    INPUTS scene.rdla
    CANONICALS scene.exr
)

