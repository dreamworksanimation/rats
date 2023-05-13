# Copyright 2023 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

add_rats_test(camera_multi
    INPUTS
        scene.rdla
    OUTPUTS
        beautyLFT.exr
        beautyRGT.exr
        aovLFT.exr
        aovRGT.exr
    IDIFF_ARGS_VECTOR -hardfail 0.07 -failpercent 0.07 -warnpercent 0.07
    IDIFF_ARGS_XPU    -hardfail 0.07 -failpercent 0.07 -warnpercent 0.07
)

