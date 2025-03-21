# Copyright 2025 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

# This tests the OverDisplayFilter.

add_rats_test(BASENAME moonray_displayfilter_basic_over
    INPUTS
        ../common.rdla
        scene.rdla
    CANONICALS
        over.exr
)

