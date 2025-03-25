# Copyright 2024 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

# This test verifies that the UsdUVTexture is working.

add_rats_test(
    INPUTS scene.rdla
    CANONICALS scene.exr
)

