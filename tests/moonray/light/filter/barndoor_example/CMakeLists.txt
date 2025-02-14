# Copyright 2024 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

# This test exercises the barndoor light filter with a basic example scene.

add_rats_test(BASENAME moonray_light_filter_barndoor_example
    INPUTS scene.rdla
    CANONICALS scene.exr
)

