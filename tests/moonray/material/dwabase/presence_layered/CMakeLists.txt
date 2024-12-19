# Copyright 2024 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

# This tests layer blending the presence property of the dwabase material

add_rats_test(moonray_material_dwabase_presence_layered
    INPUTS scene.rdla
    CANONICALS
        scene.exr
)

