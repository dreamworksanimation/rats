# Copyright 2025 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

# This tests the ability of the RenderOutput objects to output primitive attributes on parts of a USD as aovs.

add_rats_test(
    INPUTS scene.rdla
    CANONICALS result0.exr
)

