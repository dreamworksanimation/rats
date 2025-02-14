# Copyright 2024 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

# This tests the iridescence ramp color controls

add_rats_test(BASENAME moonray_material_dwabase_iridescence_ramp
    INPUTS scene.rdla
    CANONICALS
        scene.exr
)

