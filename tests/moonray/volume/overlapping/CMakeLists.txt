# Copyright 2024 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

# Tests overlapping volumes.

add_rats_test(moonray_volume_overlapping
    INPUTS overlapping.rdla
    CANONICALS scene.exr
)

