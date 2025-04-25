# Copyright 2025 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

# Tests that a map can be used for the presence value, and that
# correct shadows are cast by that map.

add_rats_test(
    INPUTS scene.rdla
    CANONICALS scene.exr
)

