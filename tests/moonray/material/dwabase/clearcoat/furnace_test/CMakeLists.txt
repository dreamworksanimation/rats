# Copyright 2024 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

# This tests energy conservation of the Clearcoat Implementation

add_rats_test(moonray_material_dwabase_clearcoat_furnace_test
    INPUTS dwabase_clearcoat_furnace_test.rdla
    CANONICALS
        scene.exr
)

