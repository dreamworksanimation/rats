# Copyright 2025 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

# This tests the HalftoneDisplayFilter.

add_rats_test(BASENAME moonray_displayfilter_basic_halftone
    INPUTS
        ../common.rdla
        scene.rdla
    CANONICALS
        halftone.exr
)

