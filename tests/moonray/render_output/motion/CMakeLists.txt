# Copyright 2025 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

# This tests the ability of the RenderOutput objects to output motion vectors.

add_rats_test(moonray_render_output_motion
    INPUTS scene.rdla
    CANONICALS scene.exr
)
