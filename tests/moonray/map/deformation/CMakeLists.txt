# Copyright 2024 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

# This tests the DeformationMap

add_rats_test(moonray_map_deformation
    INPUTS scene.rdla
    CANONICALS scene.exr
)

