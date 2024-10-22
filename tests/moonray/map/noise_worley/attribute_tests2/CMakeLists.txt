# Copyright 2024 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

# This tests more of the worley noise map shader attributes

add_rats_test(moonray_map_noise_worley_attribute_tests2
    INPUTS attribute_tests2.rdla
           ../noise_worley_common.rdla
    CANONICALS scene.exr
)

