# Copyright 2025 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

# This tests the ClampDisplayFilter.

add_rats_test(BASENAME moonray_displayfilter_basic_clamp
    INPUTS
        ../common.rdla
        scene.rdla
    CANONICALS
        clamp.exr
)

