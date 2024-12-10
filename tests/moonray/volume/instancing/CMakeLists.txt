# Copyright 2024 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

# Tests the volume instancing functionality.

add_rats_test(moonray_volume_instancing
    INPUTS instancing.rdla
    CANONICALS scene.exr
)

