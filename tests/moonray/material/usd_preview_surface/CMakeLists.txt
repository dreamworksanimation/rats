# Copyright 2024 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

# This tests all the properties of the usd preview surface material

add_rats_test(moonray_material_usd_preview_surface
    INPUTS scene.rdla
    CANONICALS
        scene.exr
)

