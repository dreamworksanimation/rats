# Copyright 2024 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

# This tests the shadow terminator fix.

add_rats_test(moonray_material_shadow_terminator
    INPUTS material_shadow_terminator.rdla
    CANONICALS
        scene.exr
)

