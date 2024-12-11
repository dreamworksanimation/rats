# Copyright 2024 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

# This tests the MultiChannelToFloatMap

add_rats_test(moonray_map_multichannel_to_float
    INPUTS scene.rdla
    CANONICALS scene.exr
)

