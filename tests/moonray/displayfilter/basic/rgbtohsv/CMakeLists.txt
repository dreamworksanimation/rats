# Copyright 2025 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

# This tests the RgbToHsvDisplayFilter.

add_rats_test(BASENAME moonray_displayfilter_basic_rgbtohsv
    INPUTS
        ../common.rdla
        scene.rdla
    CANONICALS
        rgb_to_hsv.exr
        hsv_to_rgb.exr
)

