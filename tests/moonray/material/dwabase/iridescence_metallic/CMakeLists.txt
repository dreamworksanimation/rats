# Copyright 2024 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

# This tests iridescence properties of the metallic specular lobe

add_rats_test(moonray_material_dwabase_iridescence_metallic
    INPUTS scene.rdla
    CANONICALS
        scene.exr
)

