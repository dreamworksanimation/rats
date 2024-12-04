# Copyright 2024 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

# This tests the 'use-absorbing-fibers' code path in fuzz model

add_rats_test(moonray_material_dwabase_fuzz_use_absorbing_fibers
    INPUTS dwabase_fuzz_use_absorbing_fibers.rdla
    CANONICALS
        scene.exr
)

