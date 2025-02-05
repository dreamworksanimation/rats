# Copyright 2024 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

# This tests normal mapping subsurface materials.

add_rats_test(moonray_material_sss_sss_normal
    INPUTS scene.rdla
    CANONICALS
        scene.exr
)

