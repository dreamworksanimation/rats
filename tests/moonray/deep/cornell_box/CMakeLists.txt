# Copyright 2023 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

add_rats_test(deep_cornell_box
    INPUTS
        scene.rdla
    OUTPUTS
        beauty_flat.exr
    # super high -hardfail required, presumably due to bright visible light
    # in combination with dwab compression on the beauty_flat RenderOutput
    IDIFF_ARGS_VECTOR -hardfail 0.5 -failpercent 1 -warnpercent 1
    IDIFF_ARGS_XPU    -hardfail 0.5 -failpercent 1 -warnpercent 1
)

