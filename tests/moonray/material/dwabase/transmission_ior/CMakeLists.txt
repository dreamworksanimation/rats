# Copyright 2024 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

# This tests independent transmission ior

add_rats_test(BASENAME moonray_material_dwabase_transmission_ior
    INPUTS scene.rdla
    CANONICALS
        scene.exr
)

