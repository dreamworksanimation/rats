# Copyright 2025 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

# This tests Ray Termination Lights applied on a per-object basis, and the associated light aov

add_rats_test(
    INPUTS scene.rdla
    CANONICALS
        scene.exr
        result0.exr
)

