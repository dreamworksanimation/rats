# Copyright 2023 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

add_rats_test(misc_resume_uniform_checkpoint
    DIFF_EXRHEADERS
    INPUTS scene.rdla checkpoint.rdla
    OUTPUTS checkpoint.exr
    IDIFF_ARGS_VECTOR -hardfail 0.2 -warnpercent 2.2 -failpercent 2.2
    IDIFF_ARGS_XPU    -hardfail 0.2 -warnpercent 2.2 -failpercent 2.2
)

add_rats_test(misc_resume_uniform
    DEPENDS misc_resume_uniform_checkpoint
    INPUTS scene.rdla checkpoint.rdla
    OUTPUTS render.exr
    IDIFF_ARGS_VECTOR -hardfail 0.25 -warnpercent 2.2 -failpercent 2.2
    IDIFF_ARGS_XPU    -hardfail 0.25 -warnpercent 2.2 -failpercent 2.2
)

