# Copyright 2025 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

# Tests non-uniform voxels "frustum" vdb.

add_rats_test(moonray_volume_frustum_vdb
    INPUTS frustum_vdb.rdla
    CANONICALS scene.exr
)

