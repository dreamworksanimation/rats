# Copyright 2025 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

# This tests rendering point geometry
# First  row - as spheres with color data
# Second row - with explicit shading attributes
# Third  row left - with motion blur
# Third  row right - with uv coordinates and texture mapping

add_rats_test(
    INPUTS scene.rdla
    CANONICALS
        scene.exr
)

