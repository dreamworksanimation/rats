# Copyright 2024 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

# Tests the wireframe output.

add_rats_test(moonray_render_output_wireframe
    INPUTS wireframe.rdla
    CANONICALS
        scene.exr
        wireframe.exr
)

