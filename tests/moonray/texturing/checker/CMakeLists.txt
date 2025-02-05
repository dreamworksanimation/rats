# Copyright 2025 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

# This tests the texture filter scale with a checker texture

add_rats_test(moonray_texturing_checker
    INPUTS scene.rdla
    CANONICALS
        scene.exr
)

