# Copyright 2025 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

# Tests emission from a VDB volume.

add_rats_test(BASENAME moonray_volume_emission_vdb
    INPUTS scene.rdla
    CANONICALS scene.exr
)

