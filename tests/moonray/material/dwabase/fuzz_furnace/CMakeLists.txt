# Copyright 2024 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

# This tests fuzz on all possible Dwa* materials for Energy Conservation

add_rats_test(
    INPUTS scene.rdla
    CANONICALS
        scene.exr
)

