# Copyright 2024 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

# This tests the switch material

add_rats_test(moonray_material_switch
    INPUTS material_switch.rdla
    CANONICALS
        scene.exr
)

