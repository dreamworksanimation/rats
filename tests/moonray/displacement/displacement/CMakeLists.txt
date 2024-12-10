# Copyright 2024 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

# This tests the NormalDisplacement, VectorDisplacement, SwitchDisplacement, and CombineDisplacement maps

add_rats_test(moonray_displacement_displacement
    INPUTS scene.rdla
    CANONICALS scene.exr
)

