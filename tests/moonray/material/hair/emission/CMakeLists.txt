# Copyright 2023 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

# This test verifies that the emission lobe in the hair material shader

add_rats_test(moonray_material_hair_emission
    INPUTS scene.rdla
    CANONICALS scene.exr
)

