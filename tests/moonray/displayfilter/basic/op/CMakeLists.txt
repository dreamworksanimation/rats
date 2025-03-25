# Copyright 2025 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

# This tests the OpDisplayFilter.

add_rats_test(
    INPUTS
        ../common.rdla
        scene.rdla
    CANONICALS
        acos.exr
        binary_ops.exr
        divide.exr
        math_ops.exr
        normalize.exr
        power.exr
)

