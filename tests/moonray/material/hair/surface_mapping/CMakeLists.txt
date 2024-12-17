# Copyright 2023 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

# This test verifies that the "hair surface" texture_coordinates are working

add_rats_test(moonray_material_hair_surface_mapping
    INPUTS scene.rdla
    CANONICALS scene.exr
)

