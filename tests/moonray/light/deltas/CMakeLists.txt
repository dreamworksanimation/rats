# Copyright 2025 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

# This tests 6 lights with a delta file that changes a different parameter on each light.

add_rats_test(
    INPUTS ../combined/scene.rdla
    DELTAS deltas.rdla
    CANONICALS scene.exr
)

