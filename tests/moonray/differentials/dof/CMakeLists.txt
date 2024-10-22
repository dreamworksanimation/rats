# Copyright 2023 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

# This test checks the DOF sampling

add_rats_test(moonray_differentials_dof
    INPUTS dof.rdla
    CANONICALS scene.exr
)

