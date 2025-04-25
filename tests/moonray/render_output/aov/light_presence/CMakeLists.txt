# Copyright 2025 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

# This tests the ability of the RenderOutput light aovs to handle presence

add_rats_test(
    INPUTS ../common.rdla
           scene.rdla
    CANONICALS result0.exr
)

