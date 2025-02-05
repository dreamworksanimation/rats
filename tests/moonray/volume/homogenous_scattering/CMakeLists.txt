# Copyright 2024 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

# Tests volume homogenous scattering.

add_rats_test(moonray_volume_homogenous_scattering
    INPUTS scene.rdla
    CANONICALS scene.exr
)

