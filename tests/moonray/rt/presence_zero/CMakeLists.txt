# Copyright 2025 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

# A Cornell Box containing two (invisible) planes with presence = 0.
# Tests that objects with zero presence are completely invisible.

add_rats_test(
    INPUTS scene.rdla
    CANONICALS scene.exr
)

