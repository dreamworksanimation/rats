# Copyright 2025 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

# This tests the ProjectTriplanarUdimMap

add_rats_test(moonray_map_project_triplanar_udim
    INPUTS scene.rdla
    CANONICALS scene.exr
)

