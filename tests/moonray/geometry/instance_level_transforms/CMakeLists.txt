# Copyright 2024 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

add_rats_test(moonray_geometry_instance_level_transforms
    INPUTS scene.rdla
    CANONICALS
        result.exr
        material.exr
        state.exr
    IDIFF_ARGS_VECTOR -hardfail 0.035 -failpercent 0.03 -warnpercent 0.03
    IDIFF_ARGS_XPU    -hardfail 0.035
)

