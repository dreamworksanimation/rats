# Copyright 2024 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

# This test verifies basic functionality of box geometry

add_rats_test(moonray_geometry_box
    INPUTS scene.rdla
    CANONICALS
        scene.exr
)

