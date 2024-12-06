# Copyright 2024 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

# This tests DwaLayer with respect to layering mixed models

add_rats_test(moonray_material_dwalayer_mixed_models
    INPUTS dwalayer_mixed_models.rdla
    CANONICALS
        scene.exr
)

