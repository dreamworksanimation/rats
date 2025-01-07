# Copyright 2025 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

# This test verifies invariance when changing scene scale.

add_rats_test(moonray_misc_scene_scale
    INPUTS scene_scale.rdla
    CANONICALS scene.exr
)

