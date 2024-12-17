# Copyright 2023 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

# This test tests all three modes of hair fresnel - simple, dielectric and layered.

add_rats_test(moonray_material_hair_fresnel
    INPUTS scene.rdla
    CANONICALS scene.exr
)

