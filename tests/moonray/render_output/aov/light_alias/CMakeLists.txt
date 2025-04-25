# Copyright 2025 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

# This tests the ability of the RenderOutput objects to output light aovs via lpe aliases.

add_rats_test(
    INPUTS ../common.rdla
           scene.rdla
    CANONICALS result0.exr
)

