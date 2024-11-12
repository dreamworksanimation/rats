# Copyright 2024 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

# This tests normal-mapping

add_rats_test(moonray_map_normal
    INPUTS normal.rdla
    CANONICALS scene.exr
)

