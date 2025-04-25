# Copyright 2025 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

# This test verifies that the RemapMap is working.
# A noise pattern is remapped in different ways with grayscale and per-channel controls.

add_rats_test(
    INPUTS scene.rdla
    CANONICALS scene.exr
)

