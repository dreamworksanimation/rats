# Copyright 2024 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

# This test exercises the 'rod' light filter.

add_rats_test(BASENAME moonray_light_filter_rod
    INPUTS scene.rdla
    CANONICALS scene.exr
)

