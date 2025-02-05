# Copyright 2024 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

# This test verifies attributes of UVTransform map.

add_rats_test(moonray_map_uv_transform
    INPUTS scene.rdla
    CANONICALS scene.exr
)

