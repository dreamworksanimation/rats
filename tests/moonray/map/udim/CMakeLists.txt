# Copyright 2024 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

# This tests the udim funtionality of the ImageMap

add_rats_test(moonray_map_udim
    INPUTS scene.rdla
    CANONICALS scene.exr
)

