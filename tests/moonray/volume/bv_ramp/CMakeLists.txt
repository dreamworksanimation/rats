# Copyright 2024 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

# Tests the basevolume ramp functionality.

add_rats_test(moonray_volume_bv_ramp
    INPUTS scene.rdla
    CANONICALS scene.exr
)

