# Copyright 2024 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

# This tests DwaLayer with respect to layering fabric

add_rats_test(moonray_material_dwalayer_fabric
    INPUTS scene.rdla
    CANONICALS
        scene.exr
)

