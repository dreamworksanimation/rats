# Copyright 2024 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

# This tests iridescence properties of the dielectric specular lobe

add_rats_test(moonray_material_dwabase_iridescence_dielectric
    INPUTS dwabase_iridescence_dielectric.rdla
    CANONICALS
        scene.exr
)

