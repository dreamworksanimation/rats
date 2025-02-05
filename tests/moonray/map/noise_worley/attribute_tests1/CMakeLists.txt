# Copyright 2024 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

# This tests the worley noise map shader attributes

add_rats_test(moonray_map_noise_worley_attribute_tests1
    INPUTS scene.rdla
           ../common.rdla
    CANONICALS scene.exr
)

