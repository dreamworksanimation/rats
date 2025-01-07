# Copyright 2025 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

# Tests "god rays" scattering passing through a torus.

add_rats_test(moonray_volume_godrays
    INPUTS godrays.rdla
    CANONICALS scene.exr
)

