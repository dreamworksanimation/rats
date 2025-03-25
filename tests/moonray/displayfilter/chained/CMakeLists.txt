# Copyright 2024 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

# Description: Tests the chaining functionality of display filters.

add_rats_test(
    INPUTS scene.rdla
    CANONICALS
        subOutput.exr
        desatOutput.exr
        correctOutput.exr
        final.exr
)

