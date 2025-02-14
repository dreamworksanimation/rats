# Copyright 2024 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

# This tests DwaLayer with respect to layering clearcoat

add_rats_test(BASENAME moonray_material_dwalayer_clearcoat
    INPUTS scene.rdla
    CANONICALS
        scene.exr
)

