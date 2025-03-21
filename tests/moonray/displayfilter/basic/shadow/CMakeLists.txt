# Copyright 2025 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

# This tests the ShadowDisplayFilter.

add_rats_test(BASENAME moonray_displayfilter_basic_shadow
    INPUTS
        ../common.rdla
        scene.rdla
    CANONICALS
        shadow.exr
)

