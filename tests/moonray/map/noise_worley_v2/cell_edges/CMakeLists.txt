# Copyright 2025 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

# This tests the worley noise cell_edges mode

add_rats_test(
    INPUTS scene.rdla
           ../common.rdla
    CANONICALS scene.exr
)

