# Copyright 2024 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

# This tests DwaLayer with respect to layering transmission

add_rats_test(BASENAME moonray_material_dwalayer_transmission
    INPUTS scene.rdla
    CANONICALS
        scene.exr
)

