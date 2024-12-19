# Copyright 2024 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

# This tests the Toksvig normal AA strategy

add_rats_test(moonray_material_dwabase_toksvig
    INPUTS scene.rdla
    CANONICALS
        scene.exr
)

