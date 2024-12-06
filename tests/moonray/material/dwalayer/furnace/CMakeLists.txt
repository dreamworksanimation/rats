# Copyright 2024 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

# This tests DwaLayer with respect to energy conservation

add_rats_test(moonray_material_dwalayer_furnace
    INPUTS dwalayer_furnace.rdla
    CANONICALS
        scene.exr
)

