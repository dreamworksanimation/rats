# Copyright 2025 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

# This tests the ConvolutionDisplayFilter.

add_rats_test(BASENAME moonray_displayfilter_basic_convolution
    INPUTS
        ../common.rdla
        scene.rdla
    CANONICALS
        gaussian.exr
        box.exr
        laplacian.exr
        sharpen.exr
)

