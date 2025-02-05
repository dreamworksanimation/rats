# Copyright 2024 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

# This tests the worley noise cell_edges mode

add_rats_test(moonray_map_noise_worley_cell_edges
    INPUTS scene.rdla
           ../common.rdla
    CANONICALS scene.exr
)

