# Copyright 2024 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

# This tests the presence property of the dwaemissive material

add_rats_test(moonray_material_dwaemissive_presence
    INPUTS dwaemissive_presence.rdla
    CANONICALS
        scene.exr
)

