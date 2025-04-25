# Copyright 2025 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

# This tests adaptive tessellation with resolution uniform tessellation can't handle

add_rats_test(
    INPUTS scene.rdla
    CANONICALS
        scene.exr
)

