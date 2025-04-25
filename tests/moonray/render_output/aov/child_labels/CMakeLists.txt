# Copyright 2025 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

add_rats_test(
    INPUTS scene.rdla
    CANONICALS
        scene.exr
        lpe_diffuse.exr
        lpe_material.exr
        material_specular.exr
)

