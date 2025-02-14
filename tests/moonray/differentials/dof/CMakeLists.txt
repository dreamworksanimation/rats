# Copyright 2024 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

# This test checks the DOF sampling

add_rats_test(BASENAME moonray_differentials_dof
    INPUTS scene.rdla
           ../common.rdla
    CANONICALS scene.exr
)

