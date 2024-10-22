# Copyright 2024 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

# This tests rotation order

add_rats_test(moonray_map_noise_worley_rotation_order
    INPUTS rotation_order.rdla
           ../noise_worley_common.rdla
    CANONICALS scene.exr
)

