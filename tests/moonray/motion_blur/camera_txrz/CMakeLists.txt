# Copyright 2025 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

# Tests motion-blur due to camera translation and rotation

add_rats_test(
    INPUTS ../common.rdla
           scene.rdla
    CANONICALS scene.exr
)

