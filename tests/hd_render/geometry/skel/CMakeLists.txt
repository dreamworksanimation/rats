# Copyright 2023 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

add_rats_test(BASENAME shd_render_geometry_skel
    RENDERER hd_render
    INPUTS skel.usd
    OUTPUT  scene.exr
    CANONICALS scene.exr
    RENDER_ARGS -size 256 192 -refine-level 3 -set doubleSided 0
)


