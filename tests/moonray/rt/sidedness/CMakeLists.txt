# Copyright 2024 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

# Tests single and double-sided geometry.

add_rats_test(moonray_rt_sidedness
    INPUTS sidedness.rdla
    CANONICALS scene.exr
)

