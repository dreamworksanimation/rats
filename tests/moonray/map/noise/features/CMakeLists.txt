# Copyright 2024 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

# This tests the noise map features

add_rats_test(moonray_map_noise_features
    INPUTS features.rdla
           ../noise_common.rdla
    CANONICALS scene.exr
)

