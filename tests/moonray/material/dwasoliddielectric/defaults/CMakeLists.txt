# Copyright 2024 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

# This tests default properties of the DwaSolidDelectric material

add_rats_test(moonray_material_dwasoliddielectric_defaults
    INPUTS dwasoliddielectric_defaults.rdla
    CANONICALS
        scene.exr
)

