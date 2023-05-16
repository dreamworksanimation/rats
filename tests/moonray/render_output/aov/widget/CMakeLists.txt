# Copyright 2023 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

add_rats_test(render_output_aov_widget
    DIFF_EXRHEADERS
    INPUTS
        scene.rdla
    OUTPUTS
        beauty.exr
        alpha.exr
        depth.exr
        state.exr
        # primitive.exr
        # time.exr
        wireframe.exr
        material.exr
        light.exr
        visibility.exr
        # variance.exr
        weight.exr
        cryptomatte.exr
        # displayfilter.exr
    IDIFF_ARGS_VECTOR -hardfail 0.035 -warnpercent 2.2 -failpercent 2
    IDIFF_ARGS_XPU    -hardfail 0.035 -warnpercent 2.2 -failpercent 2
)

