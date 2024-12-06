# Copyright 2024 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

# This tests DwaLayer with respect to layering metallic specular

add_rats_test(moonray_material_dwalayer_metallic_specular
    INPUTS dwalayer_metallic_specular.rdla
    CANONICALS
        scene.exr
)

