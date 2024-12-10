# Copyright 2024 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

# Tests the volume shadow set functionality.

add_rats_test(moonray_volume_shadowset
    INPUTS shadowset.rdla
    CANONICALS scene.exr
)

