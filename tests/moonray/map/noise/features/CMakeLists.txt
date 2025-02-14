# Copyright 2024 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

# This tests the noise map features

add_rats_test(BASENAME moonray_map_noise_features
    INPUTS scene.rdla
           ../common.rdla
    CANONICALS scene.exr
)

