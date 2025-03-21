# Copyright 2025 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

# This tests the RemapDisplayFilter.

add_rats_test(BASENAME moonray_displayfilter_basic_remap
    INPUTS
        ../common.rdla
        scene.rdla
    CANONICALS
        remap_uniform.exr
        remap_RGB.exr
)

