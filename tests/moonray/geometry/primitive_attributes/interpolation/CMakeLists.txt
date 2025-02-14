# Copyright 2024 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

# This tests interpolation of UserData primitive attributes

add_rats_test(BASENAME moonray_geometry_primitive_attributes_interpolation
    INPUTS scene.rdla
    CANONICALS
        scene.exr
)

