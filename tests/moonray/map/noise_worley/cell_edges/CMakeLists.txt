# Copyright 2024 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

# This tests the worley noise cell_edges mode

add_rats_test(moonray_map_noise_worley_cell_edges
    INPUTS cell_edges.rdla
           ../noise_worley_common.rdla
    CANONICALS scene.exr
)

