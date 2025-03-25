# Copyright 2023 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

# This test verifies that all the lobes in the hair material shader turned
# on simultanesouly are *functional*.

add_rats_test(
    INPUTS scene.rdla
    CANONICALS scene.exr
)

