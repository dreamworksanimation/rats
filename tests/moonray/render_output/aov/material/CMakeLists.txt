# Copyright 2024 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

# This tests the ability of the RenderOutput objects to output material aovs.

add_rats_test(
    INPUTS ../common.rdla
           scene.rdla
    CANONICALS result0.exr
)

