# Copyright 2025 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

# This tests the cubic-spline pixel filtering over high frequency geometry and texture

add_rats_test(moonray_pixel_filter_cubic
    INPUTS ../common.rdla
           pixel_filter_cubic.rdla
    CANONICALS scene.exr
)

