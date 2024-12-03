# Copyright 2024 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

# Tests volume transmittance.

add_rats_test(moonray_volume_transmittance
    INPUTS transmittance.rdla
    CANONICALS scene.exr
)

