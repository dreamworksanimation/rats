# Copyright 2023 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

add_rats_test(BASENAME moonray_misc_path_guide
    NO_VECTOR NO_XPU    # path guiding not supported in vector/xpu
    DISABLED            # this test is too slow!
    INPUTS scene.rdla
    CANONICALS scene.exr
)

