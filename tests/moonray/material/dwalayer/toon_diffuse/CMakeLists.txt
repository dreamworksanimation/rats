# Copyright 2024 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

# This tests DwaLayer with respect to layering toon diffuse

add_rats_test(moonray_material_dwalayer_toon_diffuse
    INPUTS scene.rdla
    CANONICALS
        scene.exr
)

