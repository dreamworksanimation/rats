# Copyright 2025 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

# This test tests all three modes of hair fresnel - simple, dielectric and layered.

add_rats_test(
    INPUTS scene.rdla
    CANONICALS scene.exr
)

