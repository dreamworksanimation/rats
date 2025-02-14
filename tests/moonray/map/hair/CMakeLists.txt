# Copyright 2024 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

# This tests the HairMap column_uv_color and length interpolation

add_rats_test(BASENAME moonray_map_hair
    INPUTS scene.rdla
    CANONICALS scene.exr
)

