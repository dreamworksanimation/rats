# Copyright 2024 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

# Description: Tests the chaining functionality of display filters.

add_rats_test(moonray_displayfilter_mask
    INPUTS scene.rdla
    CANONICALS
        mask.exr
        multiply_cc.exr
        convolve.exr
        halftone.exr
        op.exr
        over.exr
        r.exr
)

