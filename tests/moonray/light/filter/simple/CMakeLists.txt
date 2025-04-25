# Copyright 2025 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

# This test exercises the 'simple' light filters: combine, decay, intensity, and ramp.

add_rats_test(
    INPUTS scene.rdla
    CANONICALS scene.exr
)

