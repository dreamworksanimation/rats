# Copyright 2025 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

# This test exercises the dicing camera by showing the increased mesh resolution in the
# dicing camera's frustum.

add_rats_test(
    DISABLED    # MOONRAY-5617 this test crashes on render, needs investigation
    INPUTS scene.rdla
    CANONICALS
        wireframe.exr
)

