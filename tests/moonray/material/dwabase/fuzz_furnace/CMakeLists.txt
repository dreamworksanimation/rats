# Copyright 2024 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

# This tests fuzz on all possible Dwa* materials for Energy Conservation

add_rats_test(moonray_material_dwabase_fuzz_furnace
    INPUTS dwabase_fuzz_furnace.rdla
    CANONICALS
        scene.exr
)

