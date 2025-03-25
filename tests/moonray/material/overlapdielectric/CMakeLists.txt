# Copyright 2024 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

# This tests overlapping dielectric material priority and IOR tracking.

add_rats_test(
    INPUTS scene.rdla
    CANONICALS
        scene.exr
)

