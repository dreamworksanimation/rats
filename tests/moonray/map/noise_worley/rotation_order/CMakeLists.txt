# Copyright 2024 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

# This tests rotation order

add_rats_test(BASENAME moonray_map_noise_worley_rotation_order
    INPUTS scene.rdla
           ../common.rdla
    CANONICALS scene.exr
)

