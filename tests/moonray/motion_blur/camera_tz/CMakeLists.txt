# Copyright 2024 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

# Tests motion-blur due to camera translation around the z axis

add_rats_test(
    INPUTS ../common.rdla
           scene.rdla
    CANONICALS scene.exr
)

