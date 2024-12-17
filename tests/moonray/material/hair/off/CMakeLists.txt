# Copyright 2023 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

# This test checks that the off booleans work for all of the lobes.

add_rats_test(moonray_material_hair_off
    INPUTS scene.rdla
    CANONICALS scene.exr
)

