# Copyright 2024 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

# This test verifies shading with explicit attributes on various geometry types

add_rats_test(BASENAME moonray_geometry_explicit_attributes
    INPUTS scene.rdla
    CANONICALS
        scene.exr
)

