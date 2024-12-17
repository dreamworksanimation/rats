# Copyright 2023 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

# This test tests layering with the HairLayerMaterial

add_rats_test(moonray_material_hair_layer_basic
    INPUTS scene.rdla
    CANONICALS scene.exr
)

