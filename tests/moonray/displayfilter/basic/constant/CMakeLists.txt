# Copyright 2025 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

# This tests the ConstantDisplayFilter.

add_rats_test(BASENAME moonray_displayfilter_basic_constant
    INPUTS
        ../common.rdla
        scene.rdla
    CANONICALS
        constant.exr
)

