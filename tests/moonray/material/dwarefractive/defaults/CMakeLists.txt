# Copyright 2024 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

# This tests default properties of the DwaRefractive material

add_rats_test(moonray_material_dwarefractive_defaults
    INPUTS dwarefractive_defaults.rdla
    CANONICALS
        scene.exr
)

