# Copyright 2025 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

# This tests the quadratic-spline pixel filtering over high frequency geometry and texture

add_rats_test(
    INPUTS ../common.rdla
           scene.rdla
    CANONICALS scene.exr
)

