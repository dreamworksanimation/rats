# Copyright 2025 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

# This tests the ImageDisplayFilter.

add_rats_test(BASENAME moonray_displayfilter_basic_image
    INPUTS
        ../common.rdla
        scene.rdla
    CANONICALS
        image_no_scale.exr
        image_stretch.exr
        image_horizontal_fit.exr
        image_vertical_fit.exr
        image_fit_by_largest_dim.exr
        image_fit_by_smallest_dim.exr
)

