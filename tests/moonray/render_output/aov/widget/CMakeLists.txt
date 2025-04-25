# Copyright 2025 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

add_rats_test(
    DIFF_HEADERS
    INPUTS scene.rdla
    CANONICALS
        beauty.exr
        alpha.exr
        depth.exr
        state.exr
        # primitive.exr
        # time.exr
        wireframe.exr
        material.exr
        light.exr
        # visibility.exr
        # variance.exr
        weight.exr
        cryptomatte.exr
        # displayfilter.exr
)

