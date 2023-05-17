# Copyright 2023 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

add_rats_test(misc_path_guide
    NO_VECTOR NO_XPU    # path guiding not supported in vector/xpu
    DISABLED            # this test is too slow!
    INPUTS scene.rdla
    OUTPUTS scene.exr
    IDIFF_ARGS_SCALAR -hardfail 0.25 -fail 0.01 -warn .01 -warnpercent 0.5 -failpercent 0.5
)

