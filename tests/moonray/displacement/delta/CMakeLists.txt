# Copyright 2024 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

# This tests a delta file's effect on displacement

add_rats_test(moonray_displacement_delta
    INPUTS scene.rdla
    DELTAS deltas.rdla
    CANONICALS scene.exr
)

