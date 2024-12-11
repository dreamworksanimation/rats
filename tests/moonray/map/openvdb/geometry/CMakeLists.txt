# Copyright 2024 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

# This tests the OpenVdbMap input texture coordinates

add_rats_test(moonray_map_openvdb_geometry
    INPUTS scene.rdla
    CANONICALS scene.exr
)

