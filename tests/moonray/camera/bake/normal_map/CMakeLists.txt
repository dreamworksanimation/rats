# Copyright 2025 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

# This test creates a bake map along normals using a user supplied normal map.

add_rats_test(
    INPUTS scene.rdla
    CANONICALS
        scene.exr
)

