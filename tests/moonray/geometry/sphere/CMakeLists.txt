# Copyright 2025 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

add_rats_test(
    INPUTS scene.rdla
    CANONICALS
        result.exr
        depth.exr
        material.exr
        state.exr
)

