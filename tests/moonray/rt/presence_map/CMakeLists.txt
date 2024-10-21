# Copyright 2024 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

# Tests that a map can be used for the presence value, and that
# correct shadows are cast by that map.

add_rats_test(moonray_rt_presence_map
    INPUTS presence_map.rdla
    CANONICALS scene.exr
)

