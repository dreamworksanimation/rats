# Copyright 2025 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

# This tests the texture filter scale with a text texture

add_rats_test(moonray_texturing_text
    INPUTS texturing_text.rdla
    CANONICALS scene.exr
)
