# Copyright 2024 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

# This tests DwaLayer with respect to layering clearcoat

add_rats_test(moonray_material_dwalayer_clearcoat
    INPUTS dwalayer_clearcoat.rdla
    CANONICALS
        scene.exr
)

