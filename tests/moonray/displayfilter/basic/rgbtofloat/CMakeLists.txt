# Copyright 2025 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

# This tests the RgbToFloatDisplayFilter.

add_rats_test(BASENAME moonray_displayfilter_basic_rgbtofloat
    INPUTS
        ../common.rdla
        scene.rdla
    CANONICALS
        r.exr
        g.exr
        b.exr
        rgb_min.exr
        rgb_max.exr
        average.exr
        sum.exr
        luminance.exr
)

