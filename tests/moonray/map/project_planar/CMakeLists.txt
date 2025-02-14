# Copyright 2025 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

# This tests the ProjectPlanarMap

add_rats_test(BASENAME moonray_map_project_planar
    INPUTS scene.rdla
    CANONICALS scene.exr
)

