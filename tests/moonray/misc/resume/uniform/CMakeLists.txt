# Copyright 2023 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

# This test checks uniform sampling checkpoint/resume rendering

# NOTE: these images contain 12 channels, some of which can contain
# pixels with extremely large values. This makes finding reasonable
# idiff arguments difficult.

file(RELATIVE_PATH test_basename ${PROJECT_SOURCE_DIR}/tests/ ${CMAKE_CURRENT_SOURCE_DIR})

# create the checkpoint file
add_rats_test(
    NAME_SUFFIX -checkpoint
    DISABLED
    DIFF_HEADERS
    INPUTS scene.rdla checkpoint.rdla
    CANONICALS checkpoint_result.exr checkpoint_result0.exr
)

# do a final (resume) render from checkpoint
add_rats_test(
    NAME_SUFFIX -final
    DISABLED
    DEPENDS ${test_basename}-checkpoint
    INPUTS scene.rdla resume.rdla
    CANONICALS resume_result.exr resume_result0.exr
)

