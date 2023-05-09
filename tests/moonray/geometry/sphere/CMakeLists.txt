# Copyright 2023 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

add_rats_test(geometry_sphere
    INPUTS
        scene.rdla
    OUTPUTS
        result.exr
        material.exr
        state.exr
    IDIFF_ARGS_VECTOR -hardfail 0.035
    IDIFF_ARGS_XPU    -hardfail 0.035
)

