# Copyright 2024 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

# This tests Fuzz on DwaSolidDielectric material

add_rats_test(moonray_material_dwasoliddielectric_fuzz
    INPUTS scene.rdla
    CANONICALS
        scene.exr
)

