# Copyright 2024 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

# This tests anisotropy properties of the specular lobe using Cook-Torrance
# with Beckmann distribution using negative values

add_rats_test(BASENAME moonray_material_dwabase_anisotropy_negative
    INPUTS scene.rdla
    CANONICALS
        scene.exr
)

