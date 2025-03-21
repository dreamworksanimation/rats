# Copyright 2025 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

# This tests the ColorCorrectDisplayFilter.

add_rats_test(BASENAME moonray_displayfilter_basic_colorcorrect
    INPUTS
        ../common.rdla
        scene.rdla
    CANONICALS
        exposure.exr
        saturation.exr
        contrast.exr
        gamma.exr
        offset.exr
        multiply_cc.exr
)

