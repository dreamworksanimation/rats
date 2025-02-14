# Copyright 2024 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

# This tests a beauty render of the Clearcoat Implementation (clearcoat + absorption + thickness)

add_rats_test(BASENAME moonray_material_dwabase_clearcoat_beauty
    INPUTS scene.rdla
    CANONICALS
        scene.exr
)

