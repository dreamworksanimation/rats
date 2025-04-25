# Copyright 2025 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

# This test checks SSS blending behaviors with hair, between two diffuse nodes vs diff and spec.

add_rats_test(
    INPUTS scene.rdla
    CANONICALS scene.exr
)

