# Copyright 2024 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

# Tests random maps

add_rats_test(moonray_map_random
    INPUTS random.rdla
    CANONICALS scene.exr
)

