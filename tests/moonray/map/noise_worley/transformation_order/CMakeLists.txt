# Copyright 2024 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

# This tests the transforms and their order

add_rats_test(moonray_map_noise_worley_transformation_order
    INPUTS scene.rdla
           ../common.rdla
    CANONICALS scene.exr
)

