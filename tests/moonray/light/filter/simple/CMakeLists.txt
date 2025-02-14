# Copyright 2024 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

# This test exercises the 'simple' light filters: combine, decay, intensity, and ramp.

add_rats_test(BASENAME moonray_light_filter_simple
    INPUTS scene.rdla
    CANONICALS scene.exr
)

