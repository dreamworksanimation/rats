# Copyright 2024 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

# This tests the BlendMap

add_rats_test(BASENAME moonray_map_blend
    INPUTS scene.rdla
    CANONICALS scene.exr
)

