# Copyright 2025 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

# This test verifies bounce lighting in a room with an open door

add_rats_test(moonray_sampling_bedroom
    INPUTS scene.rdla
    CANONICALS scene.exr
)

