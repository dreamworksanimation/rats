# Copyright 2024 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

# This test exercises a bilinearly filtered env light with ray footprint based mip level selection

add_rats_test(
    INPUTS scene.rdla
    CANONICALS
        scene.exr
)

