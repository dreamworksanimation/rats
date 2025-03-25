# Copyright 2024 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

# This tests the ability of the RenderOutput objects to output extra aovs.

add_rats_test(
    INPUTS scene.rdla
    CANONICALS
        scene.exr
        result0.exr
)

