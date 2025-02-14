# Copyright 2024 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

# This tests energy conservation of the Clearcoat Implementation

add_rats_test(BASENAME moonray_material_dwabase_clearcoat_furnace_test
    INPUTS scene.rdla
    CANONICALS
        scene.exr
)

