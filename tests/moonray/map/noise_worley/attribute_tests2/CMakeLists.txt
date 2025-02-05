# Copyright 2024 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

# This tests more of the worley noise map shader attributes

add_rats_test(moonray_map_noise_worley_attribute_tests2
    INPUTS scene.rdla
           ../common.rdla
    CANONICALS scene.exr
)

