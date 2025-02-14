# Copyright 2024 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

# Tests the volume position AOV.

add_rats_test(BASENAME moonray_volume_position
    INPUTS scene.rdla
    CANONICALS scene.exr position.exr
)

