# Copyright 2024 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

# This test exercises the 'cookie_v2' light filter.

add_rats_test(BASENAME moonray_light_filter_cookie_v2
    INPUTS scene.rdla
    CANONICALS scene.exr
)

