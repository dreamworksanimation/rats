# Copyright 2023 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

# This tests that the hair material shader default behavior is not changing

add_rats_test(
    INPUTS scene.rdla
    CANONICALS scene.exr
)

