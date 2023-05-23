# Copyright 2023 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

add_rats_test(hd_render_geometry_skel
    DISABLED
    RENDERER hd_moonray
    INPUTS skel.usd
    CANONCALS
        scene.
    RENDER_ARGS
        # -in ${shot_dir}/skel.usd -out ${result} ${args} -res ${res} -size 1920 1440 -refine-level 3 -set doubleSided 0
)


