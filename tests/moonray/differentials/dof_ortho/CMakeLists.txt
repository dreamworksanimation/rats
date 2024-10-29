# Copyright 2024 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

# This test checks the DOF sampling

add_rats_test(moonray_differentials_dof_ortho
    INPUTS dof_ortho.rdla
           ../differentials_common.rdla
    CANONICALS scene.exr
)

