# Copyright 2025 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

# Tests motion-blur due to changing camera focal length

add_rats_test(
    INPUTS ../common.rdla
           scene.rdla
    CANONICALS scene.exr
)

