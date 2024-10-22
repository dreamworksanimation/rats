# Copyright 2024 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

# This tests the transforms and their order

add_rats_test(moonray_map_noise_transformation_order
    INPUTS transformation_order.rdla
           ../noise_common.rdla
    CANONICALS scene.exr
)

