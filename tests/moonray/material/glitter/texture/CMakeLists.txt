# Copyright 2025 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

# Test glitter textures
add_rats_test(
    INPUTS scene.rdla
    CANONICALS
        scene.exr
    DISABLED # MOONRAY-5670
)

