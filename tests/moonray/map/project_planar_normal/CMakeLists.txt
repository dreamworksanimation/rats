# Copyright 2025 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

# This tests the ProjectPlanarNormalMap

add_rats_test(moonray_map_project_planar_normal
    INPUTS scene.rdla
    CANONICALS scene.exr
)

