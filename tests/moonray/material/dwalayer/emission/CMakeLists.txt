# Copyright 2024 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

# This tests DwaLayer with respect to layering emission

add_rats_test(BASENAME moonray_material_dwalayer_emission
    INPUTS scene.rdla
    CANONICALS
        scene.exr
)

