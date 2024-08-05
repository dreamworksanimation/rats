# Copyright 2024 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

# This test exercises the 'cookie' light filter.

add_rats_test(moonray_light_filter_cookie
    INPUTS scene.rdla
    CANONICALS scene.exr
)

