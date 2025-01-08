# Copyright 2025 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

# Tests emission from a VDB volume.

add_rats_test(moonray_volume_emission_vdb
    INPUTS emission_vdb.rdla
    CANONICALS scene.exr
)

