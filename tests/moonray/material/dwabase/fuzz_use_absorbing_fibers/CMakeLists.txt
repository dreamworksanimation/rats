# Copyright 2024 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

# This tests the 'use-absorbing-fibers' code path in fuzz model

add_rats_test(
    INPUTS scene.rdla
    CANONICALS
        scene.exr
)

