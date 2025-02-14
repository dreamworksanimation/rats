# Copyright 2023 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

# This test checks uniform sampling checkpoint/resume rendering

# NOTE: these images contain 12 channels, some of which can contain
# pixels with extremely large values. This makes finding reasonable
# idiff arguments difficult.

# create the checkpoint file
add_rats_test(BASENAME moonray_misc_resume_uniform_checkpoint
    DIFF_HEADERS
    INPUTS scene.rdla checkpoint.rdla
    CANONICALS checkpoint_result.exr checkpoint_result0.exr
)

# do a final (resume) render from checkpoint
add_rats_test(BASENAME moonray_misc_resume_uniform_final
    DEPENDS moonray_misc_resume_uniform_checkpoint
    INPUTS scene.rdla resume.rdla
    CANONICALS resume_result.exr resume_result0.exr
)

