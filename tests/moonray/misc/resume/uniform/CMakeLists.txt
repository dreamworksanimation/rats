# Copyright 2023 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

add_rats_test(moonray_misc_resume_uniform_checkpoint
    DIFF_HEADERS
    INPUTS scene.rdla checkpoint.rdla
    CANONICALS checkpoint.exr
    IDIFF_ARGS_SCALAR -hardfail 0.12 -warnpercent 0.1 -failpercent 0.1  # TODO: why do these -hardfail settings need to be so high?
    IDIFF_ARGS_VECTOR -hardfail 0.25 -warnpercent 2.2 -failpercent 2.2
    IDIFF_ARGS_XPU    -hardfail 0.25 -warnpercent 2.2 -failpercent 2.2
)

add_rats_test(moonray_misc_resume_uniform
    DEPENDS moonray_misc_resume_uniform_checkpoint
    INPUTS scene.rdla checkpoint.rdla
    CANONICALS render.exr
    IDIFF_ARGS_SCALAR -hardfail 0.12 -warnpercent 0.1 -failpercent 0.1  # TODO: why do these -hardfail settings need to be so high?
    IDIFF_ARGS_VECTOR -hardfail 0.25 -warnpercent 2.2 -failpercent 2.2
    IDIFF_ARGS_XPU    -hardfail 0.25 -warnpercent 2.2 -failpercent 2.2
)

