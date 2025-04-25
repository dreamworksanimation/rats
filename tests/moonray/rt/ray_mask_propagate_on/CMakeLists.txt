# Copyright 2025 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

# Tests the propagate_visibility_bounce_type = true scene var.
# Internally this is the ray mask.

add_rats_test(
    INPUTS scene.rdla
    CANONICALS scene.exr
)

