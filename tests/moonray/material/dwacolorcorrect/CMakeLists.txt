# Copyright 2024 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

# This tests DwaColorCorrectMaterial

add_rats_test(moonray_material_dwacolorcorrect
    INPUTS scene.rdla
    CANONICALS
        scene.exr
)

