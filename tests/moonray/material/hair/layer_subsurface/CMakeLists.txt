# Copyright 2023 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

# This test checks SSS blending behaviors with hair, between two diffuse nodes vs diff and spec.

add_rats_test(BASENAME moonray_material_hair_layer_subsurface
    INPUTS scene.rdla
    CANONICALS scene.exr
)

