# Copyright 2024 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

# This tests normal-mapping with anisotropic bsdf

add_rats_test(moonray_map_normal_aniso
    INPUTS scene.rdla
    CANONICALS scene.exr
)

