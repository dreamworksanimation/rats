# Copyright 2024 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

# This tests the operations and op factors of the OpMap

add_rats_test(moonray_map_op
    INPUTS map_op.rdla
    CANONICALS scene.exr
)