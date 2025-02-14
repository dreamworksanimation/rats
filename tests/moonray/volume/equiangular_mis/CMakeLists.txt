# Copyright 2025 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

# Tests equiangular MIS sampling with two spherical light sources inside a cloud.

add_rats_test(BASENAME moonray_volume_equiangular_mis
    INPUTS scene.rdla
    CANONICALS scene.exr
)

